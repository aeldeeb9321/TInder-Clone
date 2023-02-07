//
//  AuthService.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 2/6/23.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let profileImage: UIImage
}

struct AuthService {
    
    static func logUserIn(withEmail email: String, password: String,
                          completion: ((AuthDataResult?, Error?) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredentials credentials: AuthCredentials,
                             completion: @escaping ((Error?) -> Void)) {
        
        Service.uploadImage(image: credentials.profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                if let error = error {
                    print("DEBUG: Error signing user up \(error.localizedDescription)")
                    return
                }
                
                //how to get user u id that was just creater
                guard let uid = result?.user.uid else { return }
                
                let data = ["email": credentials.email, "fullname": credentials.fullname, "imageUrl": imageUrl, "uid": uid, "age": 18] as [String: Any]
                
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
            }
        }
    }
}
