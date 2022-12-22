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
                    .font(.largeTitle.bold()).frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    if let urlString = resultItem.html_url,
                       let url = URL(string: urlString) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Text("Open in Safari")
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.blue, lineWidth: 2)
                        }
                        .foregroundColor(.blue)
                        
                }
            }.padding(.leading).padding(.top).padding(.trailing)
            Text(resultItem.full_name)
                .font(.body).padding(.leading).frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                AsyncImage(url: URL(string: resultItem.owner.avatar_url)) { avatar in
                    avatar.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 64, height: 64)
                Spacer()
                Text("@\(resultItem.owner.login)")
                    .font(.body.italic()).padding(.leading).frame(maxWidth: .infinity, alignment: .leading)
            }.padding(.leading).padding(.top)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
