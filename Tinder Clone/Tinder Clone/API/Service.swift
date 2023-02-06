//
//  Service.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 2/6/23.
// It doesn't make sense to put this uploadImage function in our AuthService when its going to be used for other purposes other than authenticating users.

import UIKit
import FirebaseStorage

struct Service {
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        //creating imageData to be able to upload it to the database
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        //creating a unique filename for the image so that they are easy to access later on
        let filename = NSUUID().uuidString
        //This is the storage reference for the images folder
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        ref.putData(imageData) { meta, error in
            
            if let error = error {
                print("DEBUG: Error uploading image \(error.localizedDescription)")
                return
            }
            
            
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
