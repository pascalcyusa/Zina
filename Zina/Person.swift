// Person.swift
import Foundation

struct Person: Identifiable, Codable {
    let id: UUID
    var name: String
    var meetingPlace: MeetingPlace
    var connections: Set<UUID>  // IDs of people they know
    
    init(id: UUID = UUID(), name: String, meetingPlace: MeetingPlace, connections: Set<UUID> = []) {
        self.id = id
        self.name = name
        self.meetingPlace = meetingPlace
        self.connections = connections
    }
}

enum MeetingPlace: String, CaseIterable, Codable {
    case party = "Party"
    case work = "Work"
    case school = "School Event"
    case conference = "Conference"
    case socialMedia = "Social Media"
    case other = "Other"
}