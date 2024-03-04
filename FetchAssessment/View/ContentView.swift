//
//  ContentView.swift
//  FetchAssessment
//
//  Created by ashika kalmady on 2/27/24.
//

import SwiftUI

/// `ContentView` is the main view of the application, displaying a list of meals fetched from an API.
///
/// This view initializes and observes a `MealListViewModel` to manage the fetching and display
/// of meals.
struct ContentView: View {
    /// The view model responsible for fetching meals and managing state.
    @StateObject var viewModel: MealListViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.meals) { meal in
                MealRow(meal: meal)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Meals")
            .overlay(contentOverlay)
            .onAppear(perform: viewModel.fetchMeals)
        }
    }
    
    init() {
        _viewModel = StateObject(wrappedValue: MealListViewModel()) // Initializes the view model.
    }
    
    /// Generates a view to overlay on the meal list based on the current state of meal fetching.
    @ViewBuilder
    private var contentOverlay: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Loading meals...")
        case .failed(let message):
            Text(message).foregroundColor(.red)
        case .empty:
            Text("No meals found.").foregroundColor(.gray)
        default:
            EmptyView()
        }
    }
}

/// `MealRow` represents a single row in the meal list, displaying meal information and providing navigation to meal details.
struct MealRow: View {
    let meal: Meal // The meal data to display.
    
    var body: some View {
        NavigationLink(destination: MealDetailView(viewModel: MealDetailViewModel(apiClient: URLSessionAPIClient(), mealId: meal.id))) {
            HStack {
                MealThumbnail(url: meal.thumbnailURL)
                Text(meal.name).font(.headline)
            }
        }
    }
}

/// `MealThumbnail` displays a thumbnail image for a meal, handling loading and error states gracefully.
struct MealThumbnail: View {
    let url: String?
    
    private let placeholderColor = Color.gray
    private let imageSize: CGFloat = 60
    private let cornerRadius: CGFloat = 8
    
    var body: some View {
        AsyncImage(url: URL(string: url ?? "")) { phase in
            switch phase {
            case .failure(_):
                placeholderColor.frame(width: imageSize, height: imageSize).cornerRadius(cornerRadius)
            case .success(let image):
                image.resizable().scaledToFit().frame(width: imageSize, height: imageSize).cornerRadius(cornerRadius)
            default:
                ProgressView().frame(width: imageSize, height: imageSize)
            }
        }
    }
}


#Preview {
    ContentView()
}
