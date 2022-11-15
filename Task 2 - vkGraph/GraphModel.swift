//
//  GraphModel.swift
//  IS&T
//
//  Created by Леонид on 02.11.2022.
//

import Foundation

enum EdgeType {
    case directed
    case undirected
}

struct Vertex<T> {
    let data: T
    let index: Int
}

struct Edge<T> {
    let source: Vertex<T>
    let destination: Vertex<T>
}

extension Vertex: Hashable where T: Hashable {}
extension Vertex: Equatable where T: Equatable {}

extension Vertex: CustomStringConvertible {
    var description: String{
        return "\(index):\(data)"
    }
}

protocol Graph {
    associatedtype Element
    func createVertex(data: Element) -> Vertex<Element>
    func addDirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>)
    func addUndirectedEdge(between source: Vertex<Element>, and destination: Vertex<Element>)
    func add(_ edge: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>)
    func edges(from source: Vertex<Element>) -> [Edge<Element>]
}

class AdjacencyList <T: Hashable>: Graph {
    private var adjancencies: [Vertex<T>: [Edge<T>]] = [:]
    
    func createVertex(data: T) -> Vertex<T> {
        let vertex = Vertex(data: data, index: adjancencies.count)
        adjancencies[vertex] = []
        return vertex
    }
    
    func addDirectedEdge(from source: Vertex<T>, to destination: Vertex<T>) {
        let edge = Edge(source: source, destination: destination)
        adjancencies[source]?.append(edge)
    }
    
    
    func addUndirectedEdge(between source: Vertex<T>, and destination: Vertex<T>) {
        addDirectedEdge(from: source, to: destination)
        addDirectedEdge(from: destination, to: source)
    }
    
    func add(_ edge: EdgeType, from source: Vertex<T>, to destination: Vertex<T>) {
        switch edge {
        case .directed:
            addDirectedEdge(from: source, to: destination)
        case .undirected:
            addUndirectedEdge(between: source, and: destination)
        }
    }
    
    func edges(from source: Vertex<T>) -> [Edge<T>] {
        return adjancencies[source] ?? []
    }
    
}

extension AdjacencyList: CustomStringConvertible {
    public var description: String {
        var result = ""
        for (vertex, edges) in adjancencies {
            var edgeString = ""
            for (index, edge) in edges.enumerated() {
                if index != edges.count - 1 {
                    edgeString.append("\(edge.destination), ")
                } else {
                    edgeString.append("\(edge.destination)")
                }
            }
            result.append("\(vertex) ---> [ \(edgeString) ]\n")
        }
        return result
    }
    
}
