// ConnectionsGraphView.swift
import SwiftUI

struct ConnectionsGraphView: View {
    let people: [Person]
    var onPersonSelected: ((Person) -> Void)?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 20) {
                ForEach(people) { person in
                    PersonCard(
                        person: person,
                        people: people,
                        onEdit: { selectedPerson in
                            onPersonSelected?(selectedPerson)
                        }
                    )
                }
            }
            .padding()
        }
    }
}

struct PersonCard: View {
    let person: Person
    let people: [Person]
    let onEdit: (Person) -> Void
    @State private var isHovered = false
    
    var connections: [Person] {
        people.filter { person.connections.contains($0.id) }
    }
    
    var body: some View {
        Button(action: { 
            withAnimation(.spring()) {
                onEdit(person)
            }
        }) {
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
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Theme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Theme.haloGradient, lineWidth: isHovered ? 2 : 0)
                    )
                    .shadow(
                        color: Theme.cardShadow,
                        radius: isHovered ? 12 : 8,
                        y: isHovered ? 4 : 2
                    )
            )
            .scaleEffect(isHovered ? 1.02 : 1)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.spring(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
}