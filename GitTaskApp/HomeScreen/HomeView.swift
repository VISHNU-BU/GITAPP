//
//  HomeView.swift
//  GitTaskApp
//
//  Created by VISHNU MANGALASHERY on 13/07/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = RepositoryViewModel()
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search Repositories", text: $viewModel.searchQuery, onCommit: {
                    if networkMonitor.isConnected {
                        viewModel.reset()
                        viewModel.fetchRepositories()
                    }
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.repositories) { repo in
                            NavigationLink(destination: RepoDetailsView(repository: repo)) {
                                RepositoryCardView(repository: repo)
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(.systemGray6))
                            }
                            .onAppear {
                                if viewModel.repositories.last == repo && networkMonitor.isConnected {
                                    viewModel.fetchRepositories()
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Repositories")
            .onAppear {
                if networkMonitor.isConnected {
                    viewModel.searchQuery = "swift"
                    viewModel.reset()
                    viewModel.fetchRepositories()
                } else {
                    viewModel.loadRepositories() 
                }
            }
        }
    }
}
