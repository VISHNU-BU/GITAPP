//
//  RepoDetailsView.swift
//  GitTaskApp
//
//  Created by VISHNU MANGALASHERY on 13/07/24.
//

import SwiftUI

struct RepoDetailsView: View {
    var repository: Repository
    @StateObject private var viewModel = RepositoryViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: URL(string: repository.owner.avatar_url) ?? URL(string: ""))
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            
            Text(repository.name)
                .font(.title)
            
            Text(repository.description ?? "No description available")
                .font(.body)
            
            Link("Project Link", destination: URL(string: repository.html_url)!)
                .font(.body)
                .foregroundColor(.blue)
            
            Text("Contributors")
                .font(.headline)
                .padding(.top, 10)
            
            List(viewModel.contributors) { contributor in
                NavigationLink(destination: ContributorDetailView(contributor: contributor)) {
                    HStack {
                        AsyncImage(url: URL(string: contributor.avatar_url) ?? URL(string: ""))
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        VStack(alignment: .leading) {
                            Text(contributor.login)
                                .font(.headline)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchContributors(repository: repository)
                viewModel.loadContributors()
            }
        }
        .padding()
        .navigationTitle(repository.name)
    }
}
