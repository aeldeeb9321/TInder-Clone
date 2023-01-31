//
//  ViewController.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 1/31/23.
//

import UIKit

class HomeController: UIViewController {
    
    //MARK: - Properties
    
    //instead of coding all the stackview properties and setting it up we just put it all in this custom subclass
    private let navStackView: HomeNavigationStackView = {
        let stackView = HomeNavigationStackView()
        return stackView
    }()
    
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let bottomStackView: BottomControlsStackView = {
        let stackView = BottomControlsStackView()
        stackView.setDimensions(height: 60)
        return stackView
    }()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews: [navStackView, deckView, bottomStackView])
        stack.axis = .vertical
        stack.spacing = 12
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        stack.isLayoutMarginsRelativeArrangement = true
        view.addSubview(stack)
        stack.fillSuperView(inView: view)
    }


    //MARK: - Selectors
    
}

