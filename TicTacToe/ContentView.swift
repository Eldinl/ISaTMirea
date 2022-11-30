//
//  ContentView.swift
//  TicTacToe
//
//  Created by Леонид on 30.11.2022.
//

import SwiftUI

struct ContentView: View {
    @State var turn: Players = .X
    @State var fields: [FiedType] = .init(repeating: FiedType.empty, count: 9)
    
    let colomns: [GridItem] = .init(repeating: .init(.fixed(100), spacing: 5), count: 3)
    
    var body: some View {
        VStack {
            LazyVGrid(columns: colomns, spacing: 5) {
                ForEach(0 ..< 9 , id: \.self) { index in
                    FieldView(fieldType: fields[index])
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                if turn == .X {
                                    if fields[index] == .empty {
                                        fields[index] = .xmark
                                        turn = .O
                                    }
                                } else {
                                    if fields[index] == .empty {
                                        fields[index] = .zero
                                        turn = .X
                                    }
                                }
                            }
                        }
                }
            }
            Button {
                withAnimation {
                    fields = .init(repeating: FiedType.empty, count: 9)
                }
            } label: {
                Text("Clear")
            }
        }
    }
    
    enum Players {
        case X, O
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
