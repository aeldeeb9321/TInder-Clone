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
        let label = UILabel().makeLabel(withText: "You matched with blah blah", textColor: .white, withFont: UIFont.systemFont(ofSize: 20))
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
        let button = UIButton().makeButton(withTitle: "SEND MESSAGE", titleColor: .white)
        button.addTarget(self, action: #selector(didTapSendMessage), for: .touchUpInside)
        return button
    }()
    
    private lazy var keepSwipingButton: UIButton = {
        let button = UIButton().makeButton(withTitle: "KEEP SWIPING", titleColor: .white)
        button.addTarget(self, action: #selector(didTapKeepSwiping), for: .touchUpInside)
        return button
    }()
    
    lazy var view = [
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
        
        backgroundColor = .systemRed
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    
    //MARK: - Selectors
    
    @objc private func didTapSendMessage() {
        
    }
    
    @objc private func didTapKeepSwiping() {
         
    }
}
