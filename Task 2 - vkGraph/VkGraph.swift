//
//  VkGraph.swift
//  IS&T
//
//  Created by Леонид on 01.11.2022.
//

import Foundation

class VkGraph {
    var allFriends: [FriendWitnFriends] = []
    var userId: Int
    var accessToken: String
    var networkService = NetworkService(baseURL: "http://api.vk.com/method/")
    let graph = AdjacencyList<Int>()
    
    init(userId: Int, accessToken: String) {
        self.userId = userId
        self.accessToken = accessToken
    }
    
    func getData() async throws {
        let request = RequestVk(accessToken: accessToken, userId: userId)
        try await getUserFriends(request)
    }
    
    func getUserFriends(_ request: RequestVk) async throws {
        var friends = try await getFriendByUserId(request).items.map { item in
            item.toUI()
        }
        for friend in friends {
            var friendFriends = try await getFriendByUserId(RequestVk(accessToken: accessToken, userId: friend.id)).items.map { item in
                item.toUI()
            }
            allFriends.append(FriendWitnFriends(friend: friend, friends: friendFriends))
        }
        makeGraph()
    }
    
    func getFriendByUserId(_ params: RequestVk) async throws -> ResponseVkFriends {
        let response = try await networkService.jsonRequest("friends.get",
                                                           method: .get,
                                                           parameters: params,
                                                           responseType: ResponseVkFriends.self)
        return response
        
        
        
    }
    
    func makeGraph() {
        for friend in allFriends {
            for subFriend in friend.friends {
                    graph.add(.undirected, from: graph.createVertex(data: friend.friend.id), to: graph.createVertex(data: subFriend.id))
            }
        }
    }
}
