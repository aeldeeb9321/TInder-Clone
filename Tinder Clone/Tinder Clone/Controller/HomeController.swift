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
    private var users = [User]()
    
    //instead of coding all the stackview properties and setting it up we just put it all in this custom subclass
    private let navStackView: HomeNavigationStackView = {
        let stackView = HomeNavigationStackView()
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
        configureCards()
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
            print(users)
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
        
//        let user1 = User(name: "Jane Doe", age: 22, images: [#imageLiteral(resourceName: "jane1"), #imageLiteral(resourceName: "jane3")])
//        let user2 = User(name: "Sally Ripper", age: 21, images: [#imageLiteral(resourceName: "lady5c"), #imageLiteral(resourceName: "kelly1")])
//
//        let cardView1 = CardView(viewModel: CardViewModel(user: user1))
//        let cardView2 = CardView(viewModel: CardViewModel(user: user2))
//
//        deckView.addSubview(cardView1)
//        deckView.addSubview(cardView2)
//        cardView1.fillSuperView(inView: deckView)
//        cardView2.fillSuperView(inView: deckView)
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

