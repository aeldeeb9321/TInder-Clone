//
//  ProfileViewModel.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 2/16/23.
//

import UIKit

struct ProfileViewModel {
    
    //MARK: - Properties
    
    private let user: User
    
    let userDetailsAttributedString: NSAttributedString
    
    let profession: String
    
    let bio: String
    
    var imageURLs: [URL?] {
        user.imageURLs.map({URL(string: $0)})
    }
    
    var imageCount: Int {
        return user.imageURLs.count
    }
    
    //MARK: - Init
    
    init(user: User) {
        self.user = user
        
        let attributedText = NSMutableAttributedString(string: user.name,
                                                       attributes: [.font : UIFont.boldSystemFont(ofSize: 24),.foregroundColor: UIColor.label])
        
        attributedText.append(NSAttributedString(string: "  \(user.age)",
                                                 attributes: [.font : UIFont.systemFont(ofSize: 22),.foregroundColor: UIColor.label]))
        
        self.userDetailsAttributedString = attributedText
        
        self.profession =  user.profession
        
        self.bio = user.bio
    
    }
    
}
