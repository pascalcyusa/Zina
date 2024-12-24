// ConnectionsGraphView.swift
import SwiftUI

struct ConnectionsGraphView: View {
    let people: [Person]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 20) {
                ForEach(people) { person in
                    PersonCard(person: person, people: people)
                }
            }
            .padding()
        }
    }
}

struct PersonCard: View {
    let person: Person
    let people: [Person]
    
    var connections: [Person] {
        people.filter { person.connections.contains($0.id) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.title)
                    .foregroundStyle(.blue)
                Text(person.name)
                    .font(.headline)
            }
            
            Text(person.meetingPlace.rawValue)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if !connections.isEmpty {
                VStack(alignment: .leading) {
                    Text("Knows:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    ForEach(connections.prefix(3)) { connection in
                        Text("• \(connection.name)")
                            .font(.caption)
                    }
                    
                    if connections.count > 3 {
                        Text("+ \(connections.count - 3) more")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}