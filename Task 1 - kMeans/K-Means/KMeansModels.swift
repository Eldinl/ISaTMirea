//
//  KMeansModels.swift
//  IS&T
//
//  Created by Леонид on 05.10.2022.
//

import Foundation

struct DefiniteHuman {
    let sleepHours: Double
    let work: Double
    let weight: Double
    let growth: Double
    let mireaDistance: Double
    let type: HumanType
}

struct UndefiniteHuman {
    let sleepHours: Double
    let work: Double
    let weight: Double
    let growth: Double
    let mireaDistance: Double
}

struct TeaAndCofeMap {
    var distanse: Double
    var type: HumanType
}

enum HumanType {
    case cofe, tea
}
