//
//  Model.swift
//  IOSTestAssessment
//
//  Created by Rajan on 25/04/24.
//

import Foundation

// MARK: -  Struct to represent a Post
struct Post: Decodable {
    var userId: Int?     // User Id identifier
    var id: Int? // Unique identifier
    var title: String?
    var body: String?
}


// MARK: -  Struct to represent a Comment
struct Comment: Decodable {
    var postId: Int?     // Unique identifier
    var id: Int?
    var name: String?
    var email: String?
    var body: String?
}

