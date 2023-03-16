//
//  ChatModels.swift
//  AtoZ
//
//  Created by Emizen Tech Subhash on 07/04/22.
//


import Foundation

// MARK: - ParticipantsAPI
struct ParticipantsAPI: Codable {
    let message: String
    let status: Int
    let data: ParticipantsData?
}

// MARK: - ParticipantsData
struct ParticipantsData: Codable {
    let docs: [Participant]?
    let totalDocs, limit, page, totalPages: Int
    let pagingCounter: Int
    let hasPrevPage, hasNextPage: Bool
}

// MARK: - Participant
struct Participant: Codable {
    
    let firstName, lastName, profileName: String
    let profileImage: String
    let userID: String
    
    

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case profileName
        case profileImage = "profile_image"
        case userID = "userId"
        
        
    }
}


// MARK: - ChatUserAPI
struct ChatUserAPI: Codable {
    let message: String
    let status: Int
    let data: [Participant]?
}
