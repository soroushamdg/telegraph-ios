//
//  FCollectionRefrence.swift
//  Telegraph
//
//  Created by Soro on 2022-11-01.
//

import Foundation
import FirebaseFirestore

enum FCollectionRefrence: String {
    case User
    case Recent
    case Messages
}
func FirebaseRefrence(_ collectionRefrence: FCollectionRefrence) -> CollectionReference {
    return Firestore.firestore().collection(collectionRefrence.rawValue)
}
