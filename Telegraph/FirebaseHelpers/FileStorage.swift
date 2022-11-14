//
//  FileStorage.swift
//  Telegraph
//
//  Created by Soro on 2022-11-14.
//

import Foundation
import Firebase
import ProgressHUD

let storage = Storage.storage()

class FileStorage {
    
    class func uploadImage(_ image: UIImage, directory: String, completion: @escaping (_ documentLink: String?) -> Void) {
        
        let storageRefrence = storage.reference(forURL: kFILEREFRENCE).child(directory)
        let imageData = image.jpegData(compressionQuality: 0.6)
        var task : StorageUploadTask!
        task = storageRefrence.putData(imageData!,metadata: nil,completion: { metadata, error in
            task.removeAllObservers()
            ProgressHUD.dismiss()
        
            if error != nil {
                print("error uploading image document. \(error)")
                return
            }
            
            storageRefrence.downloadURL { url, error in
                guard let downloadUrl = url else {
                    completion(nil)
                    return
                }
                completion(downloadUrl.absoluteString)
            }
        })
    }
}
