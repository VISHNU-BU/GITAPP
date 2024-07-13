//
//  ContributorViewModel.swift
//  GitTaskApp
//
//  Created by VISHNU MANGALASHERY on 13/07/24.
//

import Foundation

class ContributorViewModel: ObservableObject {
    @Published var repositories = [Repository]()
    @Published var errorMessage: String? = nil
    
    func fetchRepositories(for contributor: Contributor) {
        let url = URL(string: "https://api.github.com/users/\(contributor.login)/repos")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch data"
                }
                return
            }
            
            do {
                let decodedRepositories = try JSONDecoder().decode([Repository].self, from: data)
                DispatchQueue.main.async {
                    self.repositories = decodedRepositories
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode response"
                }
            }
        }.resume()
    }
}
