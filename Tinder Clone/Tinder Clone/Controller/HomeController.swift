//
//  ViewController.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 1/31/23.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    //MARK: - Properties
    //user needs to start out as optional because this is the root vc of our app and this is where we are fetching our user so when it starts out it will be nil
    private var user: User?
    
    private var viewModels = [CardViewModel]() {
        didSet {
            configureCards()
        }
    }
    
    //instead of coding all the stackview properties and setting it up we just put it all in this custom subclass
    private lazy var navStackView: HomeNavigationStackView = {
        let stackView = HomeNavigationStackView()
        stackView.delegate = self
        return stackView
    }()
    
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let bottomStackView: BottomControlsStackView = {
        let stackView = BottomControlsStackView()
        stackView.setDimensions(height: 60)
        return stackView
    }()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
        fetchUsers()
    }
    
    //MARK: - API
    
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Service.fetchUser(withUID: uid) { user in
            self.user = user
        }
    }
    
    private func fetchUsers() {
        Service.fetchUsers { users in
            //one line of code instead of a users.forEach and appending a viewModel with each user
            self.viewModels = users.map({CardViewModel(user: $0)})
        }
    }
    
    private func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            presentLoginController()
        } else {
            print("DEBUG: User is logged in")
        }
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
            presentLoginController()
        } catch {
            print("DEBUG: Failed to sign out..")
        }
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews: [navStackView, deckView, bottomStackView])
        stack.axis = .vertical
        stack.spacing = 12
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        stack.isLayoutMarginsRelativeArrangement = true
        view.addSubview(stack)
        stack.fillSuperView(inView: view)
    }

    private func configureCards() {
        viewModels.forEach { viewModel in
            let cardView = CardView(viewModel: viewModel)
            cardView.delegate = self
            deckView.addSubview(cardView)
            cardView.fillSuperView(inView: deckView)
        }

    }

    private func presentLoginController() {
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    //MARK: - Selectors
    
}

extension HomeController: HomeNavigationStackViewDelegate {
    func displayMessages() {
        //present Messages
        present(MessagesController(), animated: true)
    }
    
    func displaySettings() {
        //push setting controller
        guard let user = user else { return }
        let controller = SettingsController(user: user)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}

extension HomeController: SettingsControllerDelegate {
    func settingsControllerWantsToLogout(_ controller: SettingsController) {
        dismiss(animated: true)
        logOut()
    }
    
    func settingsController(_ controller: SettingsController, wantsToUpdate user: User) {
        controller.dismiss(animated: true)
        self.user = user
    }
}

//MARK: - CardViewDelegate

extension HomeController: CardViewDelegate {
    func cardView(_ view: CardView, wantsToShowProfileFor user: User) {
        print("DEBUG: Present profile controller")
    }
    
}
