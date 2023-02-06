//
//  RegistrationController.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 2/1/23.
//

import UIKit

class RegistrationController: UIViewController {
    
    //MARK: - Properties
    private var viewModel = RegistrationViewModel()
    
    private var profileImage: UIImage?
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton().makeButton(withImage: UIImage(named: "plus_photo")?.withTintColor(.white, renderingMode: .alwaysOriginal), isRounded: false)
        button.setDimensions(height: 150, width: 150)
        button.addTarget(self, action: #selector(handleAddPhotoTapped), for: .touchUpInside)
        button.layer.cornerRadius = 150 / 2
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "Email", isSecureField: false)
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()
    
    private lazy var fullNameTextField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "Full Name", isSecureField: false)
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "Password", isSecureField: true)
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton().makeButton(withTitle: "Register", titleColor: .white, buttonColor: #colorLiteral(red: 0.9162762761, green: 0.4746812582, blue: 0.6477261186, alpha: 1), isRounded: true)
        button.addTarget(self, action: #selector(handleRegisterButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var alreadyHaveAccountButton: UIButton = {
        let button = UIButton()
        let attText = NSMutableAttributedString(string: "Already an account? ", attributes: [.font : UIFont.systemFont(ofSize: 16)])
        attText.append(NSAttributedString(string: "Log In", attributes: [.font : UIFont.boldSystemFont(ofSize: 16)]))
        button.setAttributedTitle(attText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handlePresentLoginPage), for: .touchUpInside)
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
        
        view.addSubview(addPhotoButton)
        addPhotoButton.centerX(inView: view)
        addPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)

        
        let loginStack = UIStackView(arrangedSubviews: [emailTextField, fullNameTextField, passwordTextField, registerButton])
        loginStack.spacing = 16
        loginStack.axis = .vertical
        loginStack.distribution = .fillEqually
        
        view.addSubview(loginStack)
        loginStack.anchor(top: addPhotoButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 64, paddingLeading: 16, paddingTrailing: 16)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    private func configureGradientLayer() {
        let topColor = #colorLiteral(red: 0.9870117307, green: 0.3371186554, blue: 0.3815881014, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.9022251368, green: 0.0136291096, blue: 0.4533215761, alpha: 1)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0, 1]
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.frame = view.frame
        view.layer.addSublayer(gradientLayer)
       
    }
    
    private func checkFormStatus() {
        if viewModel.formIsValid {
            registerButton.isEnabled = true
            registerButton.backgroundColor = #colorLiteral(red: 0.8000829816, green: 0.01546252612, blue: 0.3419479728, alpha: 1)
        } else {
            registerButton.isEnabled = false
            registerButton.backgroundColor = #colorLiteral(red: 0.9162762761, green: 0.4746812582, blue: 0.6477261186, alpha: 1)
        }
    }
    
    //MARK: - Selectors
    
    @objc private func handleAddPhotoTapped() {
        //present image picker
        present(imagePicker, animated: true)
    }
    
    @objc private func handleRegisterButtonTapped() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        guard let profileImage = profileImage else { return }
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, profileImage: profileImage)
        
        AuthService.registerUser(withCredentials: credentials) { error in
            if let error = error {
                print("DEBUG: Error signing user up \(error.localizedDescription)")
                return
            }
            
            print("DEBUG: Successfully registered user...")
        }
    }
    
    @objc private func handlePresentLoginPage() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else {
            viewModel.fullname = sender.text
        }
        
        checkFormStatus()
    }
}

//MARK: - UIImagePickerControllerDelegate/UINavigationControllerDelegate
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = selectedImage
        addPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        addPhotoButton.layer.borderColor = UIColor(white: 1, alpha: 0.87).cgColor
        addPhotoButton.layer.borderWidth = 3
        dismiss(animated: true)
    }
}
