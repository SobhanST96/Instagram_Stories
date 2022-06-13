//
//  IGSnap.swift
//
//  Created by Ranjith Kumar on 9/28/17
//  Copyright (c) DrawRect. All rights reserved.
//

import Foundation

enum MediaType: String {
    case image
    case video
    case unknown
}

public struct IGSnap: Codable {
    let id: String
    let mediaType: String
    let url: String
    let isViewed: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case mediaType
        case url
        case isViewed
    }
    
    var kind: MediaType {
        switch mediaType {
            case MediaType.image.rawValue:
                return MediaType.image
            case MediaType.video.rawValue:
                return MediaType.video
            default:
                return MediaType.unknown
        }
    }
    
    var isDeleted: Bool {
        set{
            UserDefaults.standard.set(newValue, forKey: id)
        }
        get{
            return UserDefaults.standard.value(forKey: id) != nil
        }
    }
    
}
