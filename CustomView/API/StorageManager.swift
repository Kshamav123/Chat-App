//
//  StorageManager.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 16/11/21.
//

import Foundation
import FirebaseStorage

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
            print("&&&&&&&&&&&&&&&&&&&&&&&&&")
        })
    }
}
