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
    
    let imageURLs: [String]
    
    private var imageIndex = 0
    
    var imageUrl: URL?
    
    //MARK: - Init
    init(user: User) {
        self.user = user
        
        let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy), .foregroundColor: UIColor.white])
        
        attributedText.append(NSAttributedString(string: " \(user.age)", attributes: [.font : UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.white]))
        
        self.userInfoText = attributedText
        
        self.imageURLs = user.imageURLs
        self.imageUrl = URL(string: imageURLs[0])
    }
    
    //MARK: - Helpers
    
    mutating func showNextPhoto() {
        guard imageIndex < imageURLs.count - 1 else { return }
        imageIndex += 1
        self.imageUrl = URL(string: imageURLs[imageIndex])
    }
    
    mutating func showPreviousPhoto() {
        guard imageIndex > 0 else { return }
        imageIndex -= 1
        self.imageUrl = URL(string: imageURLs[imageIndex])
    }
    
}
