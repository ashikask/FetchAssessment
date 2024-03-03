//
//  ViewModelStateProtocol.swift
//  FetchAssessment
//
//  Created by ashika kalmady on 3/3/24.
//

import Foundation

protocol ViewModelStateProtocol: ObservableObject {
    associatedtype Data
    var state: ViewModelState<Data> { get }
}

enum ViewModelState<T> {
    case idle
    case loading
    case loaded(T)
    case failed(String)
    case empty
}
