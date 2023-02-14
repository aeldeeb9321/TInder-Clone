//
//  SettingsFooter.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 2/14/23.
//

import UIKit

protocol SettingsFooterDelegate: AnyObject {
    func handleLogout()
}

class SettingsFooter: UIView {
    
    //MARK: - Properties
    
    weak var delegate: SettingsFooterDelegate?
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton().makeButton(withTitle: "Logout", titleColor: .systemRed, buttonColor: .white, isRounded: false)
                button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureViewComponents() {
        let spacer = UIView()
        spacer.backgroundColor = .systemGroupedBackground
        
        addSubview(spacer)
        spacer.setDimensions(height: 32, width: frame.width)
        
        addSubview(logoutButton)
        logoutButton.anchor(top: spacer.bottomAnchor, leading: safeAreaLayoutGuide.leadingAnchor,
                            trailing: safeAreaLayoutGuide.trailingAnchor)
        
    }
    
    //MARK: - Selectors
    
    @objc private func handleLogout() {
        delegate?.handleLogout()
    }
}
