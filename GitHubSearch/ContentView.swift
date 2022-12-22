//
//  ContentView.swift
//  GitHubSearch
//
//  Created by Kam Hung Ho on 2022/12/20.
//

import SwiftUI

struct ContentView: View {
    private let url = "https://api.github.com/search/repositories"
    
    @State private var appTitle = "Search Github Repo."
    @State private var searchText = ""
    @State private var searchResults: GithubRepositoryModal? = nil
    @State private var resultText = ""
    @State private var searchTask: URLSessionDataTask? = nil
    @State private var currentTimer: Timer?
    
    @State private var queryCount = 0
    @State private var showDetailView = false
    
    var body: some View {
        NavigationView {
            if let searchResults = searchResults,
               searchResults.items.count > 0 {
                List {
                    ForEach(searchResults.items, id: \.self) { item in
                        NavigationLink(destination: GithubRepositoryDetailView(withResultItem: item)) {
                            RepositoryCell(repository: item)
                                .onAppear() {
                                    if searchResults.items.last == item && !searchResults.allItemsQueried {
                                        query()
                                    }
                                }
                        }
                    }
                }
                .navigationTitle(appTitle)
            } else if !searchText.isEmpty,
                      let timer = currentTimer,
                      timer.isValid {
                HStack {
                    Text("Searching.")
                    ProgressView()
                }
                .frame(height: 64)
                .navigationTitle(appTitle)
            } else {
                Text("No result found.")
                    .navigationTitle(appTitle)
            }
        }
        .searchable(text: $searchText)
        .onChange(of: searchText, perform: { newValue in
            if searchText.count > 0 {
                query(newQuery: true)
            } else {
                searchResults = nil
            }
        })
    }
    
    func query(newQuery: Bool = false, itemsPerPage: Int = 30) {
        print("Start querying \(searchText)... (Query count: \(queryCount))")
        if let oldTimer = currentTimer {
            oldTimer.invalidate()
            currentTimer = nil
        }
        if let oldSearchTask = searchTask {
            oldSearchTask.cancel()
            searchTask = nil
        }
                
        if let url = URL(string: "\(url)?q=\(searchText)&page=\((newQuery ? 0 : searchResults?.items.count ?? 0) / itemsPerPage)") {
            print("Query with url: \(url.absoluteString)")
            let newSearchTask = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200,
                       let jsonData = data {
                        do {
                            let searchResults = try JSONDecoder().decode(GithubRepositoryModal.self, from: jsonData)
                            if newQuery {
                                self.searchResults = searchResults
                            } else {
                                self.searchResults?.items.append(contentsOf: searchResults.items)
                            }
                        } catch {
                            resultText = "JSON Serialization error: \(error)"
                            print(resultText)
                        }
                    } else {
                        print("Cannot proceed internet connection. (Response code: \(httpResponse.statusCode))")
                    }
                } else {
                    print("No response found.")
                }
                queryCount += 1
            })  
            

            let executionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                self.searchTask = newSearchTask
                newSearchTask.resume()
            }
            currentTimer = executionTimer
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
