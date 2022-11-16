//
//  VkGraph.swift
//  IS&T
//
//  Created by Леонид on 01.11.2022.
//

import Foundation

class VkGraph {
    var userId: Int
    var accessToken: String
    
    var networkService = NetworkService(baseURL: "http://api.vk.com/method/")
    
    var allFriends: [FriendWitnFriends] = []
    var graph: [VkNode] = []
    var connections: [Connection] = []
    var winners: [Winner] = []
    
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
            let nodeFriend = VkNode(id: friend.friend.id)
            
            for subFriend in friend.friends {
                let subFriend = VkNode(id: subFriend.id)
                nodeFriend.connections.append(Connection(to: subFriend, weight: 1))
            }
            
            graph.append(nodeFriend)
        }
        
        for subGraph in graph {
            var sourceNode = subGraph.connections[0]

            for index in 1 ... subGraph.connections.count {
                var destinationNode = subGraph.connections[index]
                var path = shortestPath(source: sourceNode, destination: destinationNode)
                let succession: [Int] = path?.array.reversed().flatMap({ $0 as? VkNode}).map({$0.id})
                winners.append(Winner(id: succession, counts: 1))
            }
        }

        let sortedWinners = winners.sorted(by: {$0.counts < $1.counts})
        print(sortedWinners.first?.id.first)
    }
}
