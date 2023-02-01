//
//  RegistrationController.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 2/1/23.
//

import UIKit

class RegistrationController: UIViewController {
    
    //MARK: - Properties
    
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
    
    private let emailTextField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "Email", isSecureField: false)
        return tf
    }()
    
    private let fullNameTextField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "Full Name", isSecureField: false)
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "Password", isSecureField: true)
        return tf
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton().makeButton(withTitle: "Register", titleColor: .white, buttonColor: .systemPink.withAlphaComponent(0.5), isRounded: true)
        button.addTarget(self, action: #selector(handleRegisterButtonTapped), for: .touchUpInside)
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
        let topColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0, 1]
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.frame = view.frame
        view.layer.addSublayer(gradientLayer)
       
    }
    
    //MARK: - Selectors
    
    @objc private func handleAddPhotoTapped() {
        //present image picker
        present(imagePicker, animated: true)
    }
    
    @objc private func handleRegisterButtonTapped() {
        print("DEBUG: User is signing up..")
    }
    
    @objc private func handlePresentLoginPage() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UIImagePickerControllerDelegate/UINavigationControllerDelegate
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        addPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
    }
}
