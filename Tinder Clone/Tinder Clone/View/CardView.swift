 //
//  CardView.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 1/31/23.
//

import UIKit

protocol CardViewDelegate: AnyObject {
    func cardView(_ view: CardView, wantsToShowProfileFor user: User)
    func cardView(_ view: CardView, didLikeUser: Bool)
}

class CardView: UIView {
     //MARK: - Properties
    
    var viewModel: CardViewModel
    
    weak var delegate: CardViewDelegate?
    
    private lazy var barStackView: SegmentedBarView = {
        let stack = SegmentedBarView(numberOfSegments: viewModel.imageURLs.count)
        stack.setDimensions(height: 4)
        return stack
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        layer.locations = [0.5, 1.1]
        return layer
    }()
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        
        Service.shared.fetchImageData(imageUrl: viewModel.imageUrl) { result in
            switch result {
            case .success(let imagedata):
                DispatchQueue.main.async {
                    iv.image = UIImage(data: imagedata)
                }
            case .failure(let error):
                print(error)
            }
        }
        return iv
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.attributedText = viewModel.userInfoText
        return label
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton().makeButton(withImage: #imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), isRounded: false)
        button.addTarget(self, action: #selector(handleShowProfile), for: .touchUpInside)
        button.setDimensions(height: 40, width: 40)
        return button
    }()
    
    //MARK: - LifeCycle
    
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureViewUI()
        configureGestureRecognizers()
        configureBarStackView()
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
    
    private func configureBarStackView() {
        //going to use the imageUrls Array on the viewModel to help figure out how many segmented bars we want
       
        addSubview(barStackView)
        barStackView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, paddingTop: 8, paddingLeading: 8, paddingTrailing: 8)
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
                let didLike = direction == .right
                self.delegate?.cardView(self, didLikeUser: didLike)
            }
        }
    }
    
    // You dont want to put any kind of code in a view class that involves reaching out to your api regardless of design pattern architecture. This must be delegated.
    
    private func panCard(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 100
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransform.translatedBy(x: translation.x, y: translation.y)
    }
    
    //MARK: - Selectors
    @objc private func handleShowProfile() {
        delegate?.cardView(self, wantsToShowProfileFor: viewModel.user)
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
        let location = sender.location(in: self).x
        let shouldShowNextPhoto = location > self.frame.width / 2
        
        if shouldShowNextPhoto {
            viewModel.showNextPhoto()
        } else {
            viewModel.showPreviousPhoto()
        }
        
        //imageView.image = viewModel.imageToShow
        Service.shared.fetchImageData(imageUrl: viewModel.imageUrl) { [weak self] result in
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: imageData)
                    self?.barStackView.setHighlighted(index: self?.viewModel.index ?? 0)
                }
            case .failure(let error):
                print(error)
                break
            }
        }
        
        
    }
    
}
