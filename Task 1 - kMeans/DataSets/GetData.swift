//
//  GetData.swift
//  IS&T
//
//  Created by Леонид on 05.10.2022.
//

import Foundation
import CSV

class GetData {
    func getCSVData(filename: String) -> [[String]]{
        let stream = InputStream(fileAtPath: filename)!
        let csv = try! CSVReader(stream: stream, hasHeaderRow: true)
        var data: [[String]] = []
        while let row = csv.next() {
            data.append(row)
        }
        return data
    }
}
