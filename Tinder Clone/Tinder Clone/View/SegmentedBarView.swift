//
//  SegmentedBarView.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 2/16/23.
//

import UIKit

class SegmentedBarView: UIStackView {
    
    //MARK: - Init
    private var numberOfSegments: Int
    
    init(numberOfSegments: Int) {
        self.numberOfSegments = numberOfSegments
        super.init(frame: .zero)
        
        (0..<numberOfSegments).forEach { _ in
            let barView = UIView()
            barView.backgroundColor = .barDeselectedColor
            addArrangedSubview(barView)
        }
        arrangedSubviews.first?.backgroundColor =  numberOfSegments > 1 ? .white: .clear
        
        spacing = 4
        
        distribution = .fillEqually
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func setHighlighted(index: Int) {
        arrangedSubviews.forEach({$0.backgroundColor = .barDeselectedColor})
        arrangedSubviews[index].backgroundColor = numberOfSegments > 1 ? .white: .clear
    }
}
