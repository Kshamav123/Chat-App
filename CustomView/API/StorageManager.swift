//
//  StorageManager.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 16/11/21.
//

import Foundation
import FirebaseStorage
import FirebaseAuth

class StorageManager {
    
    static let shared = StorageManager()
    let storage = Storage.storage().reference()
    
    typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                //                print("failed to upload data ti firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            let reference = self.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
                
                guard let url = url else{
                    //                    print("failed to download url")
                    completion(.failure(StorageErrors.failedToDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
                
            })
        })
    }
    
    enum StorageErrors: Error {
        case failedToUpload
        case failedToDownloadUrl
    }
    
    func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        
        let reference = storage.child(path)
        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToDownloadUrl))
                return
            }
            completion(.success(url))
        })
    }
    
    
    struct ImageUploader {
        
        static  func uploadImage(image: UIImage, uid: String, completion: @escaping(String) -> Void) {
            
            let storage = Storage.storage().reference()
            
            guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
            
            storage.child("Profile").child(uid).putData(imageData, metadata: nil) { _, error in
                guard error == nil else { return }
                print("NNNNNNNNNNNNNNNNNN")
                storage.child("Profile").child(uid).downloadURL { url, error in
                    guard let url = url, error == nil else {
                        return
                    }
                    
                    let urlString = url.absoluteString
                    
                    print("Download URL: \(urlString)")
                    completion(urlString)
                    
                }
            }
        }
    }
    
    func uploadMessageImage(image: UIImage, path: String, completion: @escaping(String) -> Void) {
               
               let storage = Storage.storage().reference()
               
               guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
               
               storage.child(path).putData(imageData, metadata: nil) { _, error in
                   guard error == nil else { return }
                   
                   storage.child(path).downloadURL { url, error in
                       guard let url = url, error == nil else {
                           return
                       }
                       
                       let urlString = url.absoluteString
                       completion(urlString)
                   }
               }
           }
    
    func downloadImageWithPath(path: String, completion: @escaping(UIImage) -> Void) {
        
        let storage = Storage.storage()
        let result = storage.reference(withPath: path)
        result.getData(maxSize: 1 * 1024 * 1024) { data, error in
            guard error == nil else { return }
            if let data = data {
                let resultImage: UIImage! = UIImage(data: data)
                completion(resultImage)
            }
        }
    }
    
   
}
