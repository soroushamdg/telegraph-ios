//
//  Status.swift
//  Telegraph
//
//  Created by Soro on 2022-11-14.
//

import Foundation

enum Status: String {
    case Available = "Available"
    case Busy = "Busy"
    case AtSchool = "At school"
    case AtTheMovies = "At the movies"
    case AtWork = "AtWork"
    
    static var array: [Status] {
        var a: [Status] = []
        switch Status.Available {
        case .Available:
            a.append(.Available); fallthrough
        case .Busy:
            a.append(.Busy); fallthrough
        case .AtSchool:
            a.append(.AtSchool); fallthrough
        case .AtTheMovies:
            a.append(.AtTheMovies); fallthrough
        case .AtWork:
            a.append(.AtWork);
        }
        return a

    }
}

