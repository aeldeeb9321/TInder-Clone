//
//  Service.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 2/6/23.
// It doesn't make sense to put this uploadImage function in our AuthService when its going to be used for other purposes other than authenticating users.

import UIKit
import Firebase
import FirebaseStorage

enum NetworkError: Error {
    case BadResponse
    case BadStatusCode(Int)
    case BadData
}

final class Service {
    private let session = URLSession(configuration: .default)
    static let shared = Service()
    private var images = NSCache<NSString, NSData>()
    
    private init() {
        
    }
    
    static func fetchUser(withUID uid: String, completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        COLLECTION_USERS.getDocuments { snapshot, errror in
            //the snapshot documents comes back as an array of dictionaries
            snapshot?.documents.forEach({ document in
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                users.append(user)
            })
            completion(users)
        }
    }
    
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
    
    //we didnt make it static since we were allowed to use class level instances with it, so we are going to use a singleton to get around this issue
    func fetchImageData(imageUrl: URL?, completion: @escaping(Result<Data, NetworkError>) -> ()) {
        guard let url = imageUrl else { return }
        
        if let imageData = images.object(forKey: url.absoluteString as NSString) {
            completion(.success(imageData as Data))
            return
        }
        
        URLSession.shared.downloadTask(with: url) { localUrl, response, error in
            guard error == nil else {
                completion(.failure(NetworkError.BadData))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.BadResponse))
                return
            }
            
            guard(200...299).contains(response.statusCode) else {
                completion(.failure(NetworkError.BadStatusCode(response.statusCode)))
                return
            }
            
            guard let localUrl = localUrl else {
                completion(.failure(NetworkError.BadData))
                return
            }
            
            do {
                let imageData = try Data(contentsOf: localUrl)
                self.images.setObject(imageData as NSData, forKey: url.absoluteString as NSString)
                completion(.success(imageData))
            } catch let error {
                print(error)
            }
        }.resume()
        
    }
    
    static func saveUserData(user: User, completion: @escaping(Error?) -> Void) {
        let data = ["uid": user.uid,
                    "fullname": user.name,
                    "imageURLs": user.imageURLs,
                    "age": user.age, "bio": user.bio,
                    "profession": user.profession,
                    "minSeekingAge": user.minSeekingAge,
                    "maxSeekingAge": user.maxSeekingAge] as [String : Any]
        
        COLLECTION_USERS.document(user.uid).setData(data, completion: completion)
    }
    
}
