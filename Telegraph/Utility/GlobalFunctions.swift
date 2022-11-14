//
//  GlobalFunctions.swift
//  Telegraph
//
//  Created by Soro on 2022-11-14.
//

import Foundation

func fileNameFrom(fileUrl: String) -> String {
    let name = fileUrl.components(separatedBy: "_").last!.components(separatedBy: "?").first!.components(separatedBy: ".").first
    return name!
}
