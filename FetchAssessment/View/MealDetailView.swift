//
//  MealDetailView.swift
//  FetchAssessment
//
//  Created by ashika kalmady on 2/28/24.
//

import SwiftUI

struct MealDetailView: View {
    @StateObject var viewModel: MealDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let mealDetail = viewModel.mealDetail {
                    VStack(alignment: .leading, spacing: 20) {
                        AsyncImage(url: URL(string: mealDetail.thumbnailURL ?? "")) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray.frame(width: 100, height: 100)
                        }
                        .aspectRatio(contentMode: .fit)
                        
                        Text(mealDetail.name)
                            .font(.title)
                        
                        Text("Instructions")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        Text(mealDetail.instructions ?? "No instructions provided.")
                            .padding(.bottom, 5)
                        
                        Text("Ingredients and Measurements")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        ForEach(mealDetail.ingredientsWithMeasurements, id: \.self) { ingredient in
                            Text(ingredient)
                        }
                    }
                    
                } else {
                    ProgressView("Loading...")
                }
            }
            .padding()
            .onAppear {
                viewModel.fetchMealDetail()
            }
            .navigationTitle(viewModel.mealDetail?.name ?? "Meal Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}

#Preview {
    MealDetailView(viewModel: MealDetailViewModel(apiClient: URLSessionAPIClient(), mealId: "52893"))
}
