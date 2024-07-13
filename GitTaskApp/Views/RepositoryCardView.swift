//
//  RepositoryCardView.swift
//  GitTaskApp
//
//  Created by VISHNU MANGALASHERY on 13/07/24.
//

import SwiftUI

struct RepositoryCardView: View {
    var repository: Repository
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: URL(string: repository.owner.avatar_url))
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(repository.name)
                        .font(.headline)
                    Text(repository.owner.login)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.bottom, 10)
            
            Text(repository.description ?? "No description available")
                .font(.body)
                .lineLimit(3)
                .frame(maxHeight: .infinity, alignment: .topLeading)
            
            Link("View on GitHub", destination: URL(string: repository.html_url)!)
                .font(.body)
                .foregroundColor(.blue)
                .padding(.top, 4)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 2)
        .frame(maxWidth: .infinity, alignment: .leading) 
    }
}
