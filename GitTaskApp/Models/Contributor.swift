//
//  Contributor.swift
//  GitTaskApp
//
//  Created by VISHNU MANGALASHERY on 13/07/24.
//

import Foundation

struct Contributor: Identifiable, Codable {
    var id: Int
    var login: String
    var avatar_url: String
    var html_url: String
}
