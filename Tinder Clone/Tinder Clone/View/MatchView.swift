//
//  MatchView.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 2/22/23.
//

import UIKit

class MatchView: UIView {
    
    //MARK: - Properties
    
    private let currentUser: User
    private let matchedUser: User
    
    private let matchImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel().makeLabel(withText: "You and Megan Fox liked each other!", textColor: .white, withFont: UIFont.systemFont(ofSize: 20))
        label.textAlignment = .center
        return label
    }()
    
    private let currentUserImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "jane2"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    private let matchedUserImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "kelly2"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    private lazy var sendMessageButton: UIButton = {
        let button = SendMessageButton()
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapSendMessage), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private lazy var keepSwipingButton: UIButton = {
        let button = KeepSwipingButton(type: .system)
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapKeepSwiping), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true 
        return button
    }()
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blur)
        view.alpha = 0
        return view
    }()
    
    lazy var views = [
        matchImageView,
        descriptionLabel,
        currentUserImageView,
        matchedUserImageView,
        sendMessageButton,
        keepSwipingButton
    ]
    //MARK: - LifeCycle
    
    init(currentUser: User, matchedUser: User) {
        self.currentUser = currentUser
        self.matchedUser = matchedUser
        super.init(frame: .zero)
        
        configureViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureBlurView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        blurView.addGestureRecognizer(tap)
        
        addSubview(blurView)
        blurView.fillSuperView(inView: self)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.blurView.alpha = 1
        }

    }
    
    private func configureViewComponents() {
        
        configureBlurView()
        
        views.forEach { view in
            addSubview(view)
            view.alpha = 1
        }
        
        currentUserImageView.anchor(leading: centerXAnchor, paddingLeading: 16)
        currentUserImageView.centerY(inView: self)
        currentUserImageView.setDimensions(height: 140, width: 140)
        currentUserImageView.layer.cornerRadius = 70
        
        matchedUserImageView.anchor(trailing: centerXAnchor, paddingTrailing: 16)
        matchedUserImageView.centerY(inView: self)
        matchedUserImageView.setDimensions(height: 140, width: 140)
        matchedUserImageView.layer.cornerRadius = 70
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, leading: safeAreaLayoutGuide.leadingAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, paddingTop: 32, paddingLeading: 48, paddingTrailing: 48)
        
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, leading: safeAreaLayoutGuide.leadingAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, paddingTop: 16, paddingLeading: 48, paddingTrailing: 48)
        
        descriptionLabel.anchor(leading: safeAreaLayoutGuide.leadingAnchor, bottom: currentUserImageView.topAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, paddingBottom: 32)
        
        matchImageView.anchor(bottom: descriptionLabel.topAnchor, paddingBottom: 16)
        matchImageView.setDimensions(height: 80, width: 300)
        matchImageView.centerX(inView: self)
        
    }
    
    //MARK: - Selectors
    
    @objc private func didTapSendMessage() {
        
    }
    
    @objc private func didTapKeepSwiping() {
         
    }
    
    @objc private func handleDismissal() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }

    }
}
