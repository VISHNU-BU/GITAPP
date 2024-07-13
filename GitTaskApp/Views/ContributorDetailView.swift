//
//  ContributorDetailView.swift
//  GitTaskApp
//
//  Created by VISHNU MANGALASHERY on 13/07/24.
//


import SwiftUI

struct ContributorDetailView: View {
    var contributor: Contributor
    @StateObject private var viewModel = ContributorViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: URL(string: contributor.avatar_url))
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            
            Text(contributor.login)
                .font(.title)
            
           // Link("Profile Link", destination: URL(string: contributor.html_url)!)
               // .font(.body)
               // .foregroundColor(.blue)
            
            Text("Repositories")
                .font(.headline)
                .padding(.top, 10)
            
            List(viewModel.repositories) { repo in
                NavigationLink(destination: RepoDetailsView(repository: repo)) {
                    RepositoryCardView(repository: repo)
                }
            }
        }
        .padding()
        .navigationTitle(contributor.login)
        .onAppear {
            viewModel.fetchRepositories(for: contributor)
        }
    }
}
