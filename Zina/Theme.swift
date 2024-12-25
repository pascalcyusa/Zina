import SwiftUI

enum Theme {
    static let background = Color.black
    static let cardBackground = Color(.systemGray6)
    static let accent = Color.blue
    static let secondary = Color(.systemGray2)
    
    static let cardShadow = Color.blue.opacity(0.3)
    static let haloGradient = LinearGradient(
        colors: [.blue.opacity(0.2), .purple.opacity(0.2)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}