//
//  LoginController.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 2/1/23.
//

import UIKit

class LoginController: UIViewController {
    //MARK: - Properties
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "app_icon").withTintColor(.white, renderingMode: .alwaysOriginal)
        iv.setDimensions(height: 100, width: 100)
        return iv
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "Email", isSecureField: false)
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "Password", isSecureField: true)
        return tf
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton().makeButton(withTitle: "Log In", titleColor: .white, buttonColor: .systemPink.withAlphaComponent(0.5), isRounded: true)
        button.addTarget(self, action: #selector(handleLoginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var dontHaveAccountButton: UIButton = {
        let button = UIButton()
        let attText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [.font : UIFont.systemFont(ofSize: 16)])
        attText.append(NSAttributedString(string: "Sign Up", attributes: [.font : UIFont.boldSystemFont(ofSize: 16)]))
        button.setAttributedTitle(attText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handlePresentRegistrationPage), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Helpers
    private func configureUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        configureGradientLayer()
        
        view.addSubview(iconImageView)
        iconImageView.centerX(inView: view)
        iconImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        
        let loginStack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        loginStack.spacing = 16
        loginStack.axis = .vertical
        loginStack.distribution = .fillEqually
        
        view.addSubview(loginStack)
        loginStack.anchor(top: iconImageView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 64, paddingLeading: 16, paddingTrailing: 16)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    private func configureGradientLayer() {
        let topColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0, 1]
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.frame = view.frame
        view.layer.addSublayer(gradientLayer)
       
    }
    
    //MARK: - Selectors
    @objc private func handleLoginButtonTapped() {
        print("DEBUG: User is logging in..")
    }
    
    @objc private func handlePresentRegistrationPage() {
        navigationController?.pushViewController(RegistrationController(), animated: true)
    }
}
