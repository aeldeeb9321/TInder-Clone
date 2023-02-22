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
    
    private lazy var bottomStackView: BottomControlsStackView = {
        let stackView = BottomControlsStackView()
        stackView.delegate = self
        stackView.setDimensions(height: 60)
        return stackView
    }()
    
    //This will be the class level property to keep track of all our cardViews
    private var cardViews = [CardView]()
    //last element in our cardViews array will be our topCardView
    private var topCardView: CardView?
    
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
    
    private func saveSwipeAndCheckForMatch(forUser user: User, didLike: Bool) {
        Service.saveSwipe(forUser: user, isLiked: didLike) { error in
            // reset top card view
            self.topCardView = self.cardViews.last
            
            guard didLike == true else { return }
            
            // FIXME: - presentMatchView is not getting called
            
            Service.checkIfMatchExists(forUser: user) { didMatch in
                self.presentMatchView(forUser: user)
            }
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
        
        //This is taking all the subviews in the deckview and creating an array from it
        cardViews = deckView.subviews.map({ $0 as! CardView })
        topCardView = cardViews.last
    }

    private func presentLoginController() {
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    private func performSwipeAnimation(shouldLike: Bool) {
        let translation: CGFloat = shouldLike ? 700: -700
        guard let width = self.topCardView?.frame.width, let height = self.topCardView?.frame.height else { return }
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            self.topCardView?.frame = CGRect(x: translation, y: 0,
                                             width: width,
                                             height: height)
        } completion: { _ in
            self.topCardView?.removeFromSuperview()
            guard !self.cardViews.isEmpty else { return }
            self.cardViews.remove(at: self.cardViews.count - 1)
            self.topCardView = self.cardViews.last
        }

    }
    
    private func presentMatchView(forUser user: User) {
        guard let currentUser = self.user else { return }
        let matchView = MatchView(currentUser: currentUser, matchedUser: user)
        view.addSubview(matchView)
        matchView.fillSuperView(inView: view)
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
    func cardView(_ view: CardView, didLikeUser: Bool) {
        view.removeFromSuperview()
        //self.cardViews.remove(at: cardViews.count - 1)
        self.cardViews.removeAll(where: { view == $0 })
        
        guard let user = topCardView?.viewModel.user else { return }
        saveSwipeAndCheckForMatch(forUser: user, didLike: didLikeUser)
        
        self.topCardView = cardViews.last
        
    }
    
    func cardView(_ view: CardView, wantsToShowProfileFor user: User) {
        let controller = ProfileController(user: user)
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
}

//MARK: - BottomControlsStackViewDelegate

extension HomeController: BottomControlsStackViewDelegate {
    func handleLike() {
        // This is how we know we are always going to have a topcard
        guard let topCard = topCardView else { return }
        
        performSwipeAnimation(shouldLike: true)
        saveSwipeAndCheckForMatch(forUser: topCard.viewModel.user, didLike: true)
    }
    
    func handleDislike() {
        guard let topCard = topCardView else { return }
        performSwipeAnimation(shouldLike: false)
        Service.saveSwipe(forUser: topCard.viewModel.user, isLiked: false, completion: nil)
    }
    
    func handleRefresh() {
        print("DEBUG: User has refeshed")
    }
    
}


//MARK: - ProfileControllerDelegate

extension HomeController: ProfileControllerDelegate {
    func profileController(_ controller: ProfileController, didLikeUser user: User) {
        controller.dismiss(animated: true) {
            //since this is in the completion it wont perform the swipe animation until the dismissal is done
            self.performSwipeAnimation(shouldLike: true)
            self.saveSwipeAndCheckForMatch(forUser: user, didLike: true)
        }
        
    }
    
    func profileController(_ controller: ProfileController, didDislikeUser user: User) {
        controller.dismiss(animated: true) {
            self.performSwipeAnimation(shouldLike: false)
            // Don't need to check for a match unless it's a like
            Service.saveSwipe(forUser: user, isLiked: false, completion: nil)
        }
        
    }
    
}

