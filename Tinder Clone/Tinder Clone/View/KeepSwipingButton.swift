//
//  KeepSwipingButton.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 2/24/23.
//

import UIKit

class KeepSwipingButton: UIButton {
    
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 1, green: 0.01492757909, blue: 0.4528400898, alpha: 1)
        let rightColor = #colorLiteral(red: 1, green: 0.391284585, blue: 0.3246014118, alpha: 1)
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5 )
        return gradientLayer
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let cornerRadius = rect.height / 2
        
        // mask layer is a layer that draws a cubic bezier spline in its coordinate space
        
        let maskLayer = CAShapeLayer()
        
        // A mutable graphics path: A mathemtaical descroption of shapes or lines to be drawn in a graphics context
        
        let maskPath = CGMutablePath()
        
        // A bezier path consists of straight and curved line segments that you can render in your custom views
        maskPath.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath)
        
        //removes the middle portion of button
        maskPath.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 3, dy: 3), cornerRadius: cornerRadius).cgPath)
        
        //The path defining the shape to be rendered. Animatable.
        maskLayer.path = maskPath
        // Specfies the even-odd winding rule. Count the total number of path crossings. If the number of crossings is even, the point is outside the path. If the number of crossings is odd, the point is inside the path and the region containing it should be filled.
        maskLayer.fillRule = .evenOdd
        
        gradientLayer.mask = maskLayer
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        gradientLayer.frame = rect
    }
}
