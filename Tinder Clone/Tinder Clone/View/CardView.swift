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
        iv.image = #imageLiteral(resourceName: "jane2")
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
        configureGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //this gets called when the views finish laying out all of the subviews so it then recognizes the frame, if we do it before that we will have a frame of 0
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
    
    private func configureGestureRecognizers() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        addGestureRecognizer(tap)
    }
    
    private func resetCardPosition(sender: UIPanGestureRecognizer) {
        let direction: SwipeDirection = sender.translation(in: self).x > 100 ? .right: .left
        let shouldDismissCard = abs(sender.translation(in: self).x) > 100
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseInOut) {
            if shouldDismissCard {
                let xTranslation = CGFloat(direction.rawValue) * 600
                let offScreenTransform = self.transform.translatedBy(x: xTranslation, y: 0)
                self.transform = offScreenTransform
            } else {
                self.transform = .identity
            }
        } completion: { _ in
            if shouldDismissCard {
                self.removeFromSuperview()
            }
        }
    }
    
    private func panCard(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 100
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransform.translatedBy(x: translation.x, y: translation.y)
    }
    
    //MARK: - Selectors
    @objc private func handleInfoButtonTapped() {
        print("DEBUG: Info button tapped")
    }
    
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            //this makes sure the swiping remains smooth in the case where someone is swiping fast
            superview?.subviews.forEach({$0.layer.removeAllAnimations()})
        case .changed:
            panCard(sender: sender)
        case .ended:
            resetCardPosition(sender: sender)
        default:
            break
        }
    }
    
    @objc private func handleChangePhoto(sender: UITapGestureRecognizer) {
        print("DEBUG: Did tap on photo")
    }
}
