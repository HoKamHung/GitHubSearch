//
//  GithubRepositoryDetailView.swift
//  GitHubSearch
//
//  Created by Kam Hung Ho on 2022/12/22.
//

import SwiftUI

struct GithubRepositoryDetailView: View {
    
    @State private var resultItem: GithubRepositoryItemModal
    
    init(withResultItem item: GithubRepositoryItemModal) {
        self.resultItem = item
    }
    
    var body: some View {
        ScrollView {
            HStack {
                Text(resultItem.name)
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                if let urlString = resultItem.html_url,
                   let url = URL(string: urlString) {
                    Button {
                        UIApplication.shared.open(url)
                    } label: {
                        Text("Open in Safari")
                            .padding()
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.blue, lineWidth: 2)
                            }
                            .foregroundColor(.blue)
                        
                    }
                }
            }
            .padding(.leading)
            .padding(.top)
            .padding(.trailing)
            Text(resultItem.full_name)
                .font(.body)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                AsyncImage(url: URL(string: resultItem.owner.avatar_url)) { avatar in
                    avatar.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 64, height: 64)
                Spacer()
                Text("@\(resultItem.owner.login)")
                    .font(.body.italic())
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading)
            .padding(.top)
            if let description = resultItem.description {
                Text(description)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            HStack {
                Text("Created at: ").font(.body.bold())
                Text(resultItem.created_at)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.leading)
            .padding(.trailing)
            .padding(.top)
            if let updatedAt = resultItem.updated_at {
                HStack {
                    Text("Updated at:").font(.body.bold())
                    Text(updatedAt)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
            }
            if let lastPushedAt = resultItem.pushed_at {
                HStack {
                    Text("Last pushed at: ").font(.body.bold())
                    Text(lastPushedAt)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
            }
            Spacer()
            HStack {
                Spacer()
                VStack {
                    Text("Forks").font(.body.bold())
                    Text(String(resultItem.forks_count))
                }
                Spacer()
                VStack {
                    Text("Open Issues").font(.body.bold())
                    Text(String(resultItem.open_issues_count))
                }
                Spacer()
                VStack {
                    Text("Watchers").font(.body.bold())
                    Text(String(resultItem.watchers_count))
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            if let license = resultItem.license {
                HStack {
                    Text("License: ").font(.body.bold())
                    if let urlString = license.url,
                       let url = URL(string:urlString) {
                        Link(license.name, destination: url)
                    } else {
                        Text(license.name)
                    }
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                if let htmlUrlString = license.html_url,
                   let htmlUrl = URL(string:htmlUrlString) {
                    Link("Browse the license detail.", destination: htmlUrl)
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.top)
                        .frame(maxWidth: .infinity)
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
