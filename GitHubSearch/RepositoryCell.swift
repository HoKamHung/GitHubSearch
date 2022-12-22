//
//  RepositoryCell.swift
//  GitHubSearch
//
//  Created by Kam Hung Ho on 2022/12/21.
//

import SwiftUI

struct RepositoryCell: View {
    @ObservedObject private var repository: GithubRepositoryItemModal
    
    var body: some View {
        HStack {
            Text(repository.name).padding()
            Text("@\(repository.owner.login)").padding()
            Spacer()
        }
    }
    
    init(repository: GithubRepositoryItemModal) {
        self.repository = repository
    }
}

