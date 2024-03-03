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
            content
                .padding()
                .navigationTitle(viewModel.mealDetail?.name ?? "Meal Details")
                .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear { viewModel.fetchMealDetail() }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Loading...")
        case .failed(let message):
            Text(message).foregroundColor(.red)
        case .loaded(let mealDetail):
            MealDetailContent(mealDetail: mealDetail)
        case .idle:
            EmptyView()
        case .empty:
            Text("No meals found.").foregroundColor(.gray)
        }
    }
}


struct MealDetailContent: View {
    let mealDetail: Meal
    private let imageSize: CGFloat = 100
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            AsyncImage(url: URL(string: mealDetail.thumbnailURL ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.gray.frame(width: imageSize, height: imageSize)
            }
            .aspectRatio(contentMode: .fit)
            
            Text(mealDetail.name).font(.title)
            
            SectionHeaderView(text: "Instructions")
            Text(mealDetail.instructions ?? "No instructions provided.")
            
            SectionHeaderView(text: "Ingredients and Measurements")
            ForEach(mealDetail.ingredientsWithMeasurements, id: \.self) { ingredient in
                Text(ingredient)
            }
        }
    }
}

struct SectionHeaderView: View {
    let text: String
    
    var body: some View {
        Text(text).font(.headline).padding(.bottom, 5)
    }
}

#Preview {
    MealDetailView(viewModel: MealDetailViewModel(apiClient: URLSessionAPIClient(), mealId: "52893"))
}
