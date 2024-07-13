//
//  NetworkMonitor.swift
//  GitTaskApp
//
//  Created by VISHNU MANGALASHERY on 13/07/24.
//

import Network
import SwiftUI

class NetworkMonitor: ObservableObject {
    private var monitor: NWPathMonitor
    @Published var isConnected: Bool = false

    init() {
        monitor = NWPathMonitor()
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
    }
}
