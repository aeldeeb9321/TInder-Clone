 //
//  CardView.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 1/31/23.
//

import UIKit

class CardView: UIView {
     //MARK: - Properties
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        layer.locations = [0.5, 1.1]
        return layer
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "lady4c")
        return iv
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        let attributedText = NSMutableAttributedString(string: "Jane Doe", attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy), .foregroundColor: UIColor.white])
        
        attributedText.append(NSAttributedString(string: " 20", attributes: [.font : UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.white]))
        label.attributedText = attributedText
        return label
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton().makeButton(withImage: #imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), isRounded: false)
        button.addTarget(self, action: #selector(handleInfoButtonTapped), for: .touchUpInside)
        button.setDimensions(height: 40, width: 40)
        return button
    }()
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    //MARK: - Helpers
    private func configureViewUI() {
        backgroundColor = .systemPurple
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(imageView)
        imageView.fillSuperView(inView: self)
        
        layer.addSublayer(gradientLayer)
        
        addSubview(infoLabel)
        infoLabel.anchor(leading: safeAreaLayoutGuide.leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, paddingLeading: 16, paddingBottom: 16, paddingTrailing: 16)
        
        addSubview(infoButton)
        infoButton.centerY(inView: infoLabel)
        infoButton.anchor(trailing: safeAreaLayoutGuide.trailingAnchor, paddingTrailing: 16)
        
        
    }
    
    //MARK: - Selectors
    @objc private func handleInfoButtonTapped() {
        print("DEBUG: Info button tapped")
    }
}
