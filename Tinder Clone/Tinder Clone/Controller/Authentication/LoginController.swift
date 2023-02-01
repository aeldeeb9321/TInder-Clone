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
        iv.setDimensions(height: 85, width: 85)
        return iv
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    private func configureUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .systemRed
        view.addSubview(iconImageView)
        iconImageView.centerX(inView: view)
        iconImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)
    }
}
