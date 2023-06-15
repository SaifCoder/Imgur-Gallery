//
//  Constants.swift
//  Imgur-Gallery
//
//  Created by Saifali Terdale on 15/06/23.
//

import Foundation

public enum Constants {
    static let collectionViewCellHeight: CGFloat = 250
    static let collectionViewPadding:CGFloat = 4
    static let ClientID = string(for: "Client_ID")

    static func string(for key: String) -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String else {
            fatalError("Invalid or missing key from info.plist: \(key)")
        }
        return value
    }
}

