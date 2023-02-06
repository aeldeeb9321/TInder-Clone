//
//  LoginController.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 2/1/23.
//

import UIKit

class LoginController: UIViewController {
    //MARK: - Properties
    private var viewModel = LoginViewModel()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "app_icon").withTintColor(.white, renderingMode: .alwaysOriginal)
        iv.setDimensions(height: 100, width: 100)
        return iv
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "Email", isSecureField: false)
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "Password", isSecureField: true)
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton().makeButton(withTitle: "Log In", titleColor: .white, buttonColor: #colorLiteral(red: 0.9162762761, green: 0.4746812582, blue: 0.6477261186, alpha: 1), isRounded: true)
        button.isEnabled = false
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
        let topColor = #colorLiteral(red: 0.9227107167, green: 0.3313664198, blue: 0.3586452603, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.9022251368, green: 0.0136291096, blue: 0.4533215761, alpha: 1)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0, 1]
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.frame = view.frame
        view.layer.addSublayer(gradientLayer)
       
    }
    
    private func checkFormStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = #colorLiteral(red: 0.8000829816, green: 0.01546252612, blue: 0.3419479728, alpha: 1)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = #colorLiteral(red: 0.9162762761, green: 0.4746812582, blue: 0.6477261186, alpha: 1)
        }
    }
    
    //MARK: - Selectors
    @objc private func handleLoginButtonTapped() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        AuthService.logUserIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Erorr logging user in \(error.localizedDescription)")
                return
            }
            
            self.dismiss(animated: true)
        }
    }
    
    @objc private func handlePresentRegistrationPage() {
        navigationController?.pushViewController(RegistrationController(), animated: true)
    }
    
    @objc private func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
}
