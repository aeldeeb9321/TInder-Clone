//
//  SendMessageButton.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 2/24/23.
//

import UIKit

class SendMessageButton: UIButton {
    
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 1, green: 0.01492757909, blue: 0.4528400898, alpha: 1)
        let rightColor = #colorLiteral(red: 1, green: 0.391284585, blue: 0.3246014118, alpha: 1)
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5 )
        return gradientLayer
    }()
    
    // This draw function is how we configure the button in a custom way
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = rect.height / 2
        clipsToBounds = translatesAutoresizingMaskIntoConstraints
        gradientLayer.frame = rect
    }
}
