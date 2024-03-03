//
//  ViewModelStateProtocol.swift
//  FetchAssessment
//
//  Created by ashika kalmady on 3/3/24.
//

import Foundation

/// A protocol defining the requirements for a ViewModel's state management.
///
/// This protocol ensures that any ViewModel conforming to it will have a `state` property
/// that reflects the current state of the ViewModel in relation to data fetching or processing.
protocol ViewModelStateProtocol: ObservableObject {
    /// The type of data that the ViewModel is responsible for managing.
    associatedtype Data
    
    /// Represents the current state of the ViewModel
    /// This state drives the UI to reactively update according to the state changes.
    var state: ViewModelState<Data> { get }
}

/// Enum representing the different states of a ViewModel in relation to data fetching or processing.
///
/// - `idle`: The initial state, indicating no current activity.
/// - `loading`: Represents a state where a data fetching or processing operation is in progress.
/// - `loaded(T)`: Indicates that data has been successfully fetched or processed and is now available.
///   The associated value `T` is the type of data that has been loaded.
/// - `failed(String)`: Represents a state where a data fetching or processing operation has failed.
///   The associated value is a `String` describing the failure.
/// - `empty`: Indicates that the operation completed successfully but resulted in no data.
enum ViewModelState<T> {
    case idle
    case loading
    case loaded(T)
    case failed(String)
    case empty
}
