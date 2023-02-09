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
        view.backgroundColor = .systemPink
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
        fetchUsers()
        //logOut()
    }
    
    //MARK: - API
    
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Service.fetchUser(withUID: uid) { user in
            print("DEBUG: User's name is \(user)")
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
        let controller = UINavigationController(rootViewController: SettingsController())
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    
}

