//
//  HomeView.swift
//  Pawdle
//
//  Created by Edward Downhill on 24/06/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = GameViewModel()
    
    init(
        dogRepository: DogRepository = .live(),
        imageRepository: ImageRepository = .live()
    ) {
        _viewModel = StateObject(
            wrappedValue: GameViewModel(
                dogRepository: dogRepository,
                imageRepository: imageRepository
            )
        )
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: Size.lg.rawValue) {
                // Header with stats
                headerView
                
                // Main game content
                gameContentView
                
                Spacer()
            }
            .padding(.lg)
            .background(Color.theme.backgroundPrimary)
            .navigationTitle("Pawdle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Reset Game") {
                            viewModel.resetGame()
                        }
                        
                        Button("New Question") {
                            viewModel.nextQuestion()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(Color.theme.accent)
                    }
                }
            }
        }
        .onChange(of: viewModel.selectedBreed) { newValue in
            if let selectedBreed = newValue {
                viewModel.selectAnswer(selectedBreed)
            }
        }
        .task {
            await viewModel.startGame()
        }
        .animation(.default, value: viewModel.gameState)
    }
    
    // MARK: - Header View
    @ViewBuilder
    private var headerView: some View {
        if let progress = viewModel.progress {
            ProgressView(value: progress)
                .tint(Color.theme.accentSecondary)
        }
    }
    
    // MARK: - Game Content View
    @ViewBuilder
    private var gameContentView: some View {
        switch viewModel.gameState {
        case .loading:
            loadingView
        case let .playing(question), let .answered(question):
            VStack(spacing: Size.lg.rawValue) {
                QuestionView(
                    question: question,
                    selectedBreed: $viewModel.selectedBreed
                )
                
                PawdleButton("Next Question") {
                    viewModel.nextQuestion()
                }
                .disabled(viewModel.selectedBreed == nil)
                .opacity(viewModel.selectedBreed == nil ? 0.0 : 1.0)
            }
        case .completed:
            congratulationsView
        case let .error(message):
            errorView(message: message)
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: Size.lg.rawValue) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.theme.accent))
                .scaleEffect(1.5)
            
            Text("Loading dog breeds...")
                .textStyle(.body)
                .foregroundColor(Color.theme.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Congratulations View
    private var congratulationsView: some View {
        VStack(spacing: Size.lg.rawValue) {
            Image("dog.happy")
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
            
            Text("🎉 Great work! 🎉")
                .textStyle(.title1)
                .foregroundColor(Color.theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Spacer()
                .frame(height: 40)
            
            Text("Do you want to continute playing?")
                .textStyle(.body)
                .foregroundColor(Color.theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Size.lg)
            
            VStack(spacing: Size.md.rawValue) {
                PawdleButton("Start Infinity Mode", variant: .secondary) {
                    viewModel.continueInfinitePlay()
                }
            }
            .padding(.top, Size.md)
        }
        .padding(.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Error View
    private func errorView(message: String) -> some View {
        VStack(spacing: Size.lg.rawValue) {
            Image("dog.upset")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            Text("Oh no!")
                .textStyle(.title2)
                .foregroundColor(Color.theme.textPrimary)
            
            Text(message)
                .textStyle(.body)
                .foregroundColor(Color.theme.textSecondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                Task {
                    await viewModel.startGame()
                }
            }
            .padding(.horizontal, Size.xl)
            .padding(.vertical, Size.md)
            .background(Color.theme.accent)
            .foregroundColor(Color.theme.accentForeground)
            .clipShape(RoundedRectangle(cornerRadius: Size.sm.rawValue))
            .textStyle(.button)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#if DEBUG
#Preview {
    HomeView(dogRepository: .mock(), imageRepository: .mock())
}
#endif
