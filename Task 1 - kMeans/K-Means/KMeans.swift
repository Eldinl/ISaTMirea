//
//  KMeans.swift
//  IS&T
//
//  Created by Леонид on 05.10.2022.
//

import Foundation


class KMeans {
    
    var humans: [DefiniteHuman] = []
    var teaAndCofe: [TeaAndCofeMap] = []
    
    func parseDataToModel() {
        let data = GetData().getCSVData(filename: "DataSetKMeans.csv")
        
        for row in data {
            let sleepHours = Double(row[0]) ?? 0
            let work = Double(row[1]) ?? 0
            let weight = Double(row[2]) ?? 0
            let growth = Double(row[3]) ?? 0
            let mireaDistance = Double(row[4]) ?? 0
            var type: HumanType = .tea
            
            if row[5] == "к" {
                type = .cofe
            } else {
                type = .tea
            }
            
            humans.append(DefiniteHuman(sleepHours: sleepHours, work: work, weight: weight, growth: growth, mireaDistance: mireaDistance, type: type))
        }
    }
    
    func defineHuman(checkHuman: UndefiniteHuman) {
        parseDataToModel()
        
        for human in humans {
            let sleepHours = pow(human.sleepHours - checkHuman.sleepHours, 2)
            let work = pow(human.work - checkHuman.work, 2)
            let weight = pow(human.weight - checkHuman.weight, 2)
            let growth = pow(human.growth - checkHuman.growth, 2)
            let mireaDistance = pow(human.mireaDistance - checkHuman.mireaDistance, 2)
            let distance = sqrt(sleepHours + work + weight + growth + mireaDistance)
            teaAndCofe.append(TeaAndCofeMap(distanse: distance, type: human.type))
        }
        
        getVerdict(checkHuman: checkHuman)
    }
    
    func getVerdict(checkHuman: UndefiniteHuman) {
        let kMeansNeedNumber: Int = 10
        var teaVotes: Int = 0
        var cofeVotes: Int = 0
        var teaAndCofeSort = teaAndCofe.sorted(by: {$0.distanse < $1.distanse})
        for index in 0 ... kMeansNeedNumber {
            if teaAndCofeSort[index].type == .cofe {
                cofeVotes += 1
            } else {
                teaVotes += 1
            }
        }
        print("Coffe votes: \(cofeVotes)")
        print("Tea votes: \(teaVotes)")
    }
}
