//
//  ContentView.swift
//  Petitions
//
//  Created by William Finnis on 02/08/2021.
//

import SwiftUI

struct Petition: Codable, Identifiable {
    let id: String
    let title: String
    let body: String
    let signatureCount: Int
    let signatureThreshold: Int
}

struct ContentView: View {
    @State var petitions = [Petition]()
    
    var body: some View {
        NavigationView {
            List(petitions) { petition in
                NavigationLink(destination: Text(petition.body)) {
                    VStack {
                        Text(petition.title)
                            .badge("\(petition.signatureCount)/\(petition.signatureThreshold)")
                        ProgressView(value: Double(petition.signatureCount), total: Double(petition.signatureThreshold))
                    }
                }
            }
            .navigationTitle("Petitions")
            .task {
                do {
                    let url = URL(string: "https://hws.dev/petitions.json")!
                    let (data, _) = try await URLSession.shared.data(from: url)
                    petitions = try JSONDecoder().decode([Petition].self, from: data)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
