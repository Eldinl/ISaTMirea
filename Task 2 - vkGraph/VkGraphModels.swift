//
//  VkGraphModels.swift
//  IS&T
//
//  Created by Леонид on 01.11.2022.
//

import Foundation

struct ResponseVkFriends: Decodable {
    var count: Int
    var items: [FriendAPI]
}

struct FriendAPI: Decodable {
    var id: Int
    var nickname: String
    var track_code: String
    var firstName: String
    var lastName: String
    var canAccessClosed: Bool
    var isClosed: Bool
}

struct FriendWitnFriends {
    var friend: FriendUI
    var friends: [FriendUI]
}

struct RequestVk: Encodable {
    var accessToken: String
    var userId: Int
    var order: String = "name"
    var fields: String = "nickname"
    var v: Double = 5.131
}

struct FriendUI: Hashable {
    var id: Int
    var nickname: String
    var firstName: String
    var lastName: String
}

extension FriendAPI{
    func toUI() -> FriendUI {
        FriendUI(id: id,
                 nickname: nickname,
                 firstName: firstName,
                 lastName: lastName)
    }
}

struct Winner {
    var id: [Int]
    var counts: Int
}
