//
//  ContentView.swift
//  FetchAssessment
//
//  Created by ashika kalmady on 2/27/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: MealListViewModel
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.isLoading {
                    ProgressView("Loading meals...")
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ForEach(viewModel.meals) { meal in
                        NavigationLink(destination: MealDetailView(viewModel: MealDetailViewModel(apiClient: URLSessionAPIClient(), mealId: meal.id))) {
                            
                            HStack {
                                AsyncImage(url: URL(string: meal.thumbnailURL ?? "")) {
                                    phase in
                                    switch phase {
                                    case .failure(_):
                                        Color.gray
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(8)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(8)
                                    default:
                                        ProgressView()
                                            .frame(width: 60, height: 60)
                                    }
                                    
                                }
                                
                                Text(meal.name)
                                    .font(.headline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Meals")
            .onAppear {
                viewModel.fetchMeals()
            }
        }
    }
}

#Preview {
    ContentView(viewModel: MealListViewModel(apiClient: URLSessionAPIClient(), category: "Dessert"))
}
