// AddPersonWizard.swift
import SwiftUI

struct AddPersonWizard: View {
    @Environment(\.dismiss) private var dismiss
    let savedPeople: [Person]
    let onSave: (Person) -> Void
    
    @State private var currentStep = 0
    @State private var name = ""
    @State private var meetingPlace = MeetingPlace.party
    @State private var selectedConnections = Set<UUID>()
    
    var body: some View {
        NavigationStack {
            VStack {
                ProgressView(value: Double(currentStep), total: 3)
                    .padding()
                    .tint(Theme.accent)
                
                TabView(selection: $currentStep) {
                    // Step 1: Name
                    NameInputView(name: $name)
                        .tag(0)
                    
                    // Step 2: Meeting Place
                    MeetingPlaceView(meetingPlace: $meetingPlace)
                        .tag(1)
                    
                    // Step 3: Connections
                    ConnectionsSelectionView(
                        savedPeople: savedPeople,
                        selectedConnections: $selectedConnections
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Navigation buttons
                HStack {
                    if currentStep > 0 {
                        Button("Back") {
                            withAnimation {
                                currentStep -= 1
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    Spacer()
                    
                    Button(currentStep == 2 ? "Save" : "Next") {
                        if currentStep == 2 {
                            savePerson()
                        } else {
                            withAnimation {
                                currentStep += 1
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(currentStep == 0 && name.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Add New Connection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func savePerson() {
        let newPerson = Person(
            name: name,
            meetingPlace: meetingPlace,
            connections: selectedConnections
        )
        onSave(newPerson)
        dismiss()
    }
}

// Step Views
struct NameInputView: View {
    @Binding var name: String
    @FocusState private var isNameFocused: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Text("What's their name?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            TextField("", text: $name)
                .focused($isNameFocused)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Theme.cardBackground)
                        .shadow(color: Theme.cardShadow, radius: 8, y: 4)
                )
                .overlay(
                    Text(name.isEmpty ? "Enter name" : "")
                        .foregroundStyle(.gray)
                )
        }
        .padding(30)
        .onAppear { isNameFocused = true }
    }
}

struct MeetingPlaceView: View {
    @Binding var meetingPlace: MeetingPlace
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Where did you meet?")
                .font(.title2)
                .fontWeight(.semibold)
            
            List {
                ForEach(MeetingPlace.allCases, id: \.self) { place in
                    HStack {
                        Text(place.rawValue)
                        Spacer()
                        if place == meetingPlace {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        meetingPlace = place
                    }
                }
            }
        }
    }
}

// Make sure ConnectionsSelectionView filters out empty state
struct ConnectionsSelectionView: View {
    let savedPeople: [Person]
    @Binding var selectedConnections: Set<UUID>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Who do they know?")
                .font(.title2)
                .fontWeight(.semibold)
            
            if savedPeople.isEmpty {
                Text("No existing connections yet")
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                List {
                    ForEach(savedPeople) { person in
                        HStack {
                            Text(person.name)
                            Spacer()
                            if selectedConnections.contains(person.id) {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Theme.accent)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.2)) {
                                if selectedConnections.contains(person.id) {
                                    selectedConnections.remove(person.id)
                                } else {
                                    selectedConnections.insert(person.id)
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .padding()
    }
}