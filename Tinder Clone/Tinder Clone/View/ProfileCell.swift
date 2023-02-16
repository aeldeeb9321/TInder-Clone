//
//  ProfileCell.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 2/15/23.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureCellComponents() {
        addSubview(imageView)
        imageView.fillSuperView(inView: self)
    }
}
