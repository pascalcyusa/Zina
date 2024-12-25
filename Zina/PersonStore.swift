// PersonStore.swift
import Foundation

@MainActor
class PersonStore: ObservableObject {
    @Published private(set) var people: [Person] = []
    private let savePath = URL.documentsDirectory.appending(path: "savedPeople.json")
    
    init() {
        loadPeople()
    }
    
    func add(_ person: Person) {
        let newPerson = person // Changed from var to let
        
        // Add bidirectional connections
        for connectionID in person.connections {
            if let index = people.firstIndex(where: { $0.id == connectionID }) {
                people[index].connections.insert(newPerson.id)
            }
        }
        
        people.append(newPerson)
        save()
    }
    
    func delete(_ person: Person) {
        // Remove bidirectional connections
        for connectionID in person.connections {
            if let index = people.firstIndex(where: { $0.id == connectionID }) {
                people[index].connections.remove(person.id)
            }
        }
        
        people.removeAll(where: { $0.id == person.id })
        save()
    }
    
    func update(_ person: Person) {
        guard let index = people.firstIndex(where: { $0.id == person.id }) else { return }
        
        // Remove old connections
        let oldConnections = people[index].connections
        for connectionID in oldConnections {
            if let connIndex = people.firstIndex(where: { $0.id == connectionID }) {
                people[connIndex].connections.remove(person.id)
            }
        }
        
        // Add new connections
        for connectionID in person.connections {
            if let connIndex = people.firstIndex(where: { $0.id == connectionID }) {
                people[connIndex].connections.insert(person.id)
            }
        }
        
        people[index] = person
        save()
    }
    
    private func loadPeople() {
        do {
            let data = try Data(contentsOf: savePath)
            people = try JSONDecoder().decode([Person].self, from: data)
        } catch {
            people = []
        }
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(people)
            try data.write(to: savePath)
        } catch {
            print("Error saving people: \(error.localizedDescription)")
        }
    }
}