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
    @State private var personToEdit: Person?
    @State private var isGraphView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background
                    .ignoresSafeArea()
                
                VStack {
                    if personStore.people.isEmpty {
                        EmptyStateView()
                    } else {
                        if isGraphView {
                            NetworkGraphView(people: personStore.people)
                                .transition(.move(edge: .trailing))
                        } else {
                            ConnectionsGridView(
                                people: personStore.people,
                                onPersonSelected: { person in
                                    personToEdit = person
                                }
                            )
                            .transition(.move(edge: .leading))
                        }
                    }
                }
            }
            .navigationTitle("My Connections")
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if !personStore.people.isEmpty {
                        Button(action: {
                            withAnimation(.spring(duration: 0.6)) {
                                isGraphView.toggle()
                            }
                        }) {
                            Image(systemName: isGraphView ? "square.grid.2x2" : "network")
                                .font(.title2)
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        withAnimation {
                            showingAddPerson = true
                        }
                    }) {
                        Image(systemName: "person.badge.plus")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddPerson) {
                AddPersonWizard(savedPeople: personStore.people) { newPerson in
                    personStore.add(newPerson)
                }
            }
            .sheet(item: $personToEdit) { person in
                EditPersonSheet(
                    person: person,
                    savedPeople: personStore.people,
                    onUpdate: { updatedPerson in
                        personStore.update(updatedPerson)
                    },
                    onDelete: { person in
                        personStore.delete(person)
                    }
                )
            }
        }
        .preferredColorScheme(.dark)
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
