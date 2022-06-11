//
//  IGStory.swift
//
//  Created by Ranjith Kumar on 9/8/17
//  Copyright (c) DrawRect. All rights reserved.
//

import Foundation

struct IGStory: Codable {
    // Note: To retain lastPlayedSnapIndex value for each story making this type as class
    public var snapsCount: Int {
        return snaps.count
    }
    
    // To carry forwarding non-deleted snaps.
//    public var snaps: [IGSnap] {
//        return _snaps.filter{!($0.isDeleted)}
//    }
    
    let id: String
    let expiresAt: String
    let createdAt: String
    let updatedAt: String
    // To hold the json snaps.
    var snaps: [IGSnap]
    let thumbnailUrl: String
    let title: String
    
    var lastPlayedSnapIndex = 0
    var isCompletelyVisible = false
    var isCancelledAbruptly = false
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case expiresAt
        case createdAt
        case updatedAt
        case snaps
        case thumbnailUrl
        case title
    }
}

extension IGStory: Equatable {
    public static func == (lhs: IGStory, rhs: IGStory) -> Bool {
        return lhs.id == rhs.id
    }
}
