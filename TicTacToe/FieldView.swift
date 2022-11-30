//
//  FieldView.swift
//  TicTacToe
//
//  Created by Леонид on 30.11.2022.
//

import SwiftUI

struct FieldView: View, Hashable {
    var id: UUID
    var fieldType: FiedType
    var color: Color?
    
    init(fieldType: FiedType) {
        self.id = UUID()
        self.fieldType = fieldType
    }
    
    init(fieldType: FiedType, color: Color) {
        self.id = UUID()
        self.fieldType = fieldType
        self.color = color
    }
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(color ?? .white)
                .frame(width: 100, height: 100)
            switch fieldType {
                case .xmark:
                    Image(systemName: "xmark")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 90, height: 90)
                case .empty:
                    EmptyView()
                case .zero:
                    Image(systemName: "circle")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 90, height: 90)
            }
        }
    }
}

enum FiedType {
    case xmark, zero, empty
}

struct FieldView_Previews: PreviewProvider {
    static var previews: some View {
        FieldView(fieldType: .xmark)
    }
}
