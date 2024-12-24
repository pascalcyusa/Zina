import SwiftUI

struct EditPersonSheet: View {
    @Environment(\.dismiss) private var dismiss
    let person: Person
    let savedPeople: [Person]
    let onUpdate: (Person) -> Void
    let onDelete: (Person) -> Void
    
    @State private var name: String
    @State private var meetingPlace: MeetingPlace
    @State private var selectedConnections: Set<UUID>
    @State private var showingDeleteAlert = false
    
    init(person: Person, savedPeople: [Person], onUpdate: @escaping (Person) -> Void, onDelete: @escaping (Person) -> Void) {
        self.person = person
        self.savedPeople = savedPeople
        self.onUpdate = onUpdate
        self.onDelete = onDelete
        
        // Initialize state
        _name = State(initialValue: person.name)
        _meetingPlace = State(initialValue: person.meetingPlace)
        _selectedConnections = State(initialValue: person.connections)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Info") {
                    TextField("Name", text: $name)
                    Picker("Meeting Place", selection: $meetingPlace) {
                        ForEach(MeetingPlace.allCases, id: \.self) { place in
                            Text(place.rawValue)
                                .tag(place)
                        }
                    }
                }
                
                Section("Connections") {
                    if savedPeople.count <= 1 {
                        Text("No other connections available")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(savedPeople.filter { $0.id != person.id }) { otherPerson in
                            HStack {
                                Text(otherPerson.name)
                                Spacer()
                                if selectedConnections.contains(otherPerson.id) {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.blue)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if selectedConnections.contains(otherPerson.id) {
                                    selectedConnections.remove(otherPerson.id)
                                } else {
                                    selectedConnections.insert(otherPerson.id)
                                }
                            }
                        }
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete Connection")
                        }
                    }
                }
            }
            .navigationTitle("Edit Connection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .alert("Delete Connection", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    onDelete(person)
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete this connection? This action cannot be undone.")
            }
        }
    }
    
    private func saveChanges() {
        let updatedPerson = Person(
            id: person.id,
            name: name,
            meetingPlace: meetingPlace,
            connections: selectedConnections
        )
        onUpdate(updatedPerson)
        dismiss()
    }
}