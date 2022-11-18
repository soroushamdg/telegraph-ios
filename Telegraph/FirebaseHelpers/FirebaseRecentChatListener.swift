//
//  RecentChatListener.swift
//  Telegraph
//
//  Created by Soro on 2022-11-18.
//

import Foundation
import Firebase

class FirebaseRecentListener {
    static let shared = FirebaseRecentListener()
    
    private init() {}
    
    func addRecent(_ recent: RecentChat) {
        do{
            try FirebaseRefrence(.Recent).document(recent.id).setData(from: recent)
        }catch{
            print("Error saving recent chat ",error.localizedDescription)
        }
    }
}
