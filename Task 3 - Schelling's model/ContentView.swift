//
//  ContentView.swift
//  Task 3 - Schelling's model
//
//  Created by Леонид on 12.11.2022.
//

import SwiftUI


struct Human: Hashable {
    var id: UUID
    var color: Color
}

struct ContentView: View {
    let edgeCount: Int = 50
    var elementsCount: Int {
        edgeCount * edgeCount
    }
    
    var field: [Human] {
        let redHumans = [Human](repeating: Human(id: UUID(), color: .red), count: Int(Double(elementsCount) * 0.45))
        let blueHumans = [Human](repeating: Human(id: UUID(), color: .blue), count: Int(Double(elementsCount) * 0.45))
        let blackHumans = [Human](repeating: Human(id: UUID(), color: .black), count: Int(Double(elementsCount) * 0.1))
        let field = redHumans + blueHumans + blackHumans
        return field.shuffled()
    }
    
    let colomns: [GridItem] = Array.init(repeating: GridItem(.fixed(7), spacing: 5), count: 50)
    
    var body: some View {
        ScrollView {
            VStack(spacing: 5) {
                Text(String(field.count))
                LazyVGrid(columns: colomns, spacing: 5) {
                    ForEach(1 ..< elementsCount, id: \.self) { index in
                        Rectangle()
                            .foregroundColor(field[index].color)
                            .frame(width: 7, height: 7)
                    }
                }

            }
//            .frame(width: 1000, height: 1000)
            .background(Color.black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
