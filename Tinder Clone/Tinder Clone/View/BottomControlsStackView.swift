//
//  BottomControlsStackView.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 1/31/23.
//

import UIKit

protocol BottomControlsStackViewDelegate: AnyObject {
    func handleLike()
    func handleDislike()
    func handleRefresh()
}

class BottomControlsStackView: UIStackView {
    //MARK: - Properties
    
    weak var delegate: BottomControlsStackViewDelegate?
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton().makeButton(withImage: #imageLiteral(resourceName: "refresh_circle").withRenderingMode(.alwaysOriginal), isRounded: false)
        button.setDimensions(height: 40, width: 40)
        button.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var dislikeButton: UIButton = {
        let button = UIButton().makeButton(withImage: #imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), isRounded: false)
        button.setDimensions(height: 40, width: 40)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(dislikeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var superLikeButton: UIButton = {
        let button = UIButton().makeButton(withImage: #imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal), isRounded: false)
        button.setDimensions(height: 40, width: 40)
        button.addTarget(self, action: #selector(superLikeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton().makeButton(withImage: #imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal), isRounded: false)
        button.setDimensions(height: 40, width: 40)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var boostButton: UIButton = {
        let button = UIButton().makeButton(withImage: #imageLiteral(resourceName: "boost_circle").withRenderingMode(.alwaysOriginal), isRounded: false)
        button.setDimensions(height: 40, width: 40)
        button.addTarget(self, action: #selector(boostButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func configureView() {
        [refreshButton, dislikeButton, superLikeButton, likeButton, boostButton].forEach { view in
            addArrangedSubview(view)
        }
        distribution = .fillEqually
    }
    
    //MARK: - Selectors
    @objc private func refreshButtonTapped() {
        delegate?.handleRefresh()
    }
    
    @objc private func dislikeButtonTapped() {
        delegate?.handleDislike()
    }
    
    @objc private func superLikeButtonTapped() {
        
    }
    
    @objc private func likeButtonTapped() {
        delegate?.handleLike()
    }
    
    @objc private func boostButtonTapped() {
        
    }
    
}
