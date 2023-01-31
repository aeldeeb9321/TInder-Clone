//
//  HomeNavigationStackView.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 1/31/23.
//

import UIKit

class HomeNavigationStackView: UIStackView {
    //MARK: - Properties
    private lazy var settingsButton: UIButton = {
        let button = UIButton().makeButton(withImage: #imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), isRounded: false)
        button.setDimensions(height: 40, width: 40)
        button.addTarget(self, action: #selector(handleSettingsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var messageButton: UIButton = {
        let button = UIButton().makeButton(withImage: #imageLiteral(resourceName: "top_messages_icon").withRenderingMode(.alwaysOriginal), isRounded: false)
        button.setDimensions(height: 40, width: 40)
        button.addTarget(self, action: #selector(handleMessageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tinderIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "app_icon")
        iv.setDimensions(height: 40, width: 40)
        return iv
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func configureView() {
        [settingsButton, tinderIconImageView, messageButton].forEach { view in
            addArrangedSubview(view)
        }
        distribution = .equalSpacing
        isLayoutMarginsRelativeArrangement = true
    }
    
    //MARK: - Selectors
    @objc private func handleSettingsButtonTapped() {
        
    }
    
    @objc private func handleMessageButtonTapped() {
        
    }
}
