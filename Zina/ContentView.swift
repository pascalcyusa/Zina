//
//  ContentView.swift
//  Zina
//
//  Created by Pascal Cyusa on 12/24/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var personStore = PersonStore()
    @State private var showingAddPerson = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if personStore.people.isEmpty {
                    EmptyStateView()
                } else {
                    ConnectionsGraphView(people: personStore.people)
                }
            }
            .navigationTitle("My Connections")
            .toolbar {
                Button(action: {
                    showingAddPerson = true
                }) {
                    Image(systemName: "person.badge.plus")
                        .font(.title2)
                }
            }
            .sheet(isPresented: $showingAddPerson) {
                AddPersonWizard(savedPeople: .constant(personStore.people)) { person in
                    personStore.add(person)
                }
            }
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.2.circle")
                .font(.system(size: 60))
                .foregroundStyle(.tint)
            Text("No Connections Yet")
                .font(.title2)
                .fontWeight(.medium)
            Text("Add people you meet to start building your network")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

#Preview {
    ContentView()
}
