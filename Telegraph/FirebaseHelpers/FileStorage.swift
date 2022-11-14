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
        
        task.observe(StorageTaskStatus.progress) { storageTaskSnapshot in
            let progress = storageTaskSnapshot.progress!.completedUnitCount / storageTaskSnapshot.progress!.totalUnitCount
            ProgressHUD.showProgress(CGFloat(progress))
        }
    }
    
    class func downloadImage(imageUrl: String,completion: @escaping (_ image:UIImage?) -> Void){
        print("URL is ", imageUrl)
        let imageFileName = fileNameFrom(fileUrl: imageUrl)
        if fileExistsAtPath(path: imageFileName) {
            
        }else{
            
        }
    }
    
    //MARK: SAVE LOCALLY
    class func saveFileLocally(fileData : NSData, fileName: String){
        let documentUrl = getDocumentsURL().appendingPathComponent(fileName, isDirectory: false)
        fileData.write(to: documentUrl,atomically: true)
    }
}

//MARK: HELPERS
func fileInDocumentsDirectory(fileName: String) -> String {
    return getDocumentsURL().appendingPathComponent(fileName).path
}
func getDocumentsURL() -> URL{
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}

func fileExistsAtPath(path: String) -> Bool {
    var doesExist = false
    let filePath = fileInDocumentsDirectory(fileName: path)
    let fileManager = FileManager.default
    doesExist = fileManager.fileExists(atPath: filePath)
    return doesExist
}
