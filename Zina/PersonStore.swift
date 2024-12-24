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
        people.append(person)
        save()
    }
    
    func delete(_ person: Person) {
        if let index = people.firstIndex(where: { $0.id == person.id }) {
            people.remove(at: index)
            save()
        }
    }
    
    func update(_ person: Person) {
        if let index = people.firstIndex(where: { $0.id == person.id }) {
            people[index] = person
            save()
        }
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