//
//  SettingsHeader.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 2/9/23.
//

import UIKit

protocol SettingsHeaderDelegate: AnyObject {
    func settingsHeader(_ header: SettingsHeader, didSelect index: Int)
}

class SettingsHeader: UIView {
    
    //MARK: - Properties
    
    var buttons = [UIButton]()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureViewComponents() {
        backgroundColor = .systemGroupedBackground
        let button1 = createButton()
        let button2 = createButton()
        let button3 = createButton()
        
        addSubview(button1)
        button1.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, paddingTop: 16, paddingLeading: 16, paddingBottom: 16)
        button1.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [button2, button3])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.anchor(top: topAnchor, leading: button1.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, paddingTop: 16, paddingLeading: 16, paddingBottom: 16, paddingTrailing: 16)
    }
    
    private func createButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    //MARK: - Selectors
    
    @objc private func handleSelectPhoto() {
        //delegate method
    }
}
