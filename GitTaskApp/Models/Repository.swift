//
//  Repository.swift
//  GitTaskApp
//
//  Created by VISHNU MANGALASHERY on 13/07/24.
//

import Foundation

struct Repository: Identifiable, Codable, Equatable {
    var id: Int
    var name: String
    var description: String?
    var html_url: String
    var owner: Owner
    
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id
    }
}

