//
//  CardViewModel.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 1/31/23.
//

import UIKit

struct CardViewModel {
    //MARK: - Properties
    let user: User
    
    let userInfoText: NSAttributedString
    
    private var imageIndex = 0
    
   // lazy var imageToShow = user.images.first!
    
    //MARK: - Init
    init(user: User) {
        self.user = user
        
        let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy), .foregroundColor: UIColor.white])
        
        attributedText.append(NSAttributedString(string: " \(user.age)", attributes: [.font : UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.white]))
        
        self.userInfoText = attributedText
    }
    
    //MARK: - Helpers
    
    mutating func showNextPhoto() {
//        guard imageIndex < user.images.count - 1 else { return }
//        imageIndex += 1
//        self.imageToShow = user.images[imageIndex]
    }
    
    mutating func showPreviousPhoto() {
//        guard imageIndex > 0 else { return }
//        imageIndex -= 1
//        self.imageToShow = user.images[imageIndex]
    }
    
}
