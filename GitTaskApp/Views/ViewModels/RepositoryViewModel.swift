//
//  RepositoryViewModel.swift
//  GitTaskApp
//
//  Created by VISHNU MANGALASHERY on 13/07/24.
//

import Foundation
import CoreData

class RepositoryViewModel: ObservableObject {
    @Published var repositories = [Repository]()
    @Published var contributors = [Contributor]()
    @Published var searchQuery = ""
    @Published var page = 1
    @Published var errorMessage: String? = nil
    private var canLoadMore = true
    
    private let context = PersistenceController.shared.container.viewContext

    func fetchRepositories() {
        guard canLoadMore else { return }
        
        let query = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "https://api.github.com/search/repositories?q=\(query)&page=\(page)&per_page=10")!
        
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
                let decodedResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                DispatchQueue.main.async {
                    self.repositories.append(contentsOf: decodedResponse.items)
                    self.saveRepositories(decodedResponse.items)
                    self.canLoadMore = decodedResponse.items.count == 10
                    self.page += 1
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode response"
                }
            }
        }.resume()
    }
    
    func saveRepositories(_ repositories: [Repository]) {
        let itemsToSave = repositories.prefix(15)
        
        itemsToSave.forEach { repo in
            let entity = RepositoryEntity(context: context)
            entity.id = Int64(repo.id)
            entity.name = repo.name
            entity.desc = repo.description
            entity.html_url = repo.html_url
            entity.avatar_url = repo.owner.avatar_url
            entity.login = repo.owner.login
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save repositories: \(error.localizedDescription)")
        }
    }

    func loadRepositories() {
        let fetchRequest: NSFetchRequest<RepositoryEntity> = RepositoryEntity.fetchRequest()
        
        do {
            let savedRepositories = try context.fetch(fetchRequest)
            self.repositories = savedRepositories.map { repoEntity in
                Repository(id: Int(repoEntity.id), name: repoEntity.name ?? "", description: repoEntity.desc, html_url: repoEntity.html_url ?? "", owner: Owner(login: repoEntity.login ?? "", avatar_url: repoEntity.avatar_url ?? ""))
            }
        } catch {
            print("Failed to fetch repositories: \(error.localizedDescription)")
        }
    }


    func fetchContributors(repository: Repository) {
        let url = URL(string: "https://api.github.com/repos/\(repository.owner.login)/\(repository.name)/contributors")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch contributors"
                }
                return
            }
            
            do {
                let decodedContributors = try JSONDecoder().decode([Contributor].self, from: data)
                DispatchQueue.main.async {
                    self.contributors = decodedContributors
                    self.saveContributors(decodedContributors)
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode contributors"
                }
            }
        }.resume()
    }
    
    func saveContributors(_ contributors: [Contributor]) {
        contributors.forEach { contributor in
            let entity = ContributorEntityy(context: context)
            entity.id = Int64(contributor.id)
            entity.login = contributor.login
            entity.avatar_url = contributor.avatar_url
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save contributors: \(error.localizedDescription)")
        }
    }
    
    func loadContributors() {
        let fetchRequest: NSFetchRequest<ContributorEntityy> = ContributorEntityy.fetchRequest()
        
        do {
            let savedContributors = try context.fetch(fetchRequest)
            self.contributors = savedContributors.map { contributorEntity in
                Contributor(id: Int(contributorEntity.id), login: contributorEntity.login ?? "", avatar_url: contributorEntity.avatar_url ?? "", html_url: contributorEntity.html_url ?? "")
            }
        } catch {
            print("Failed to fetch contributors: \(error.localizedDescription)")
        }
    }



    func reset() {
        repositories = []
        contributors = []
        page = 1
        canLoadMore = true
    }
}
