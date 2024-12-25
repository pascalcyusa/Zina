import SwiftUI

struct NetworkGraphView: View {
    let people: [Person]
    @State private var positions: [UUID: CGPoint] = [:]
    @State private var draggedPerson: UUID?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Connection lines
                ForEach(people) { person in
                    ForEach(person.connections.sorted(), id: \.self) { connectionID in
                        if let start = positions[person.id],
                           let end = positions[connectionID] {
                            Path { path in
                                path.move(to: start)
                                path.addLine(to: end)
                            }
                            .stroke(Theme.accent.opacity(0.3), lineWidth: 2)
                        }
                    }
                }
                
                // Node circles
                ForEach(people) { person in
                    Circle()
                        .fill(Theme.cardBackground)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text(person.name.prefix(2).uppercased())
                                .font(.title2.bold())
                                .foregroundStyle(Theme.accent)
                        )
                        .shadow(color: Theme.cardShadow, radius: 10)
                        .position(positions[person.id] ?? randomPosition(in: geometry))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    positions[person.id] = value.location
                                    draggedPerson = person.id
                                }
                                .onEnded { _ in
                                    draggedPerson = nil
                                }
                        )
                        .animation(.spring(dampingFraction: 0.6), value: positions[person.id])
                }
            }
            .onAppear {
                // Initialize random positions if not set
                for person in people {
                    if positions[person.id] == nil {
                        positions[person.id] = randomPosition(in: geometry)
                    }
                }
            }
        }
    }
    
    private func randomPosition(in geometry: GeometryProxy) -> CGPoint {
        CGPoint(
            x: CGFloat.random(in: 50...(geometry.size.width - 50)),
            y: CGFloat.random(in: 50...(geometry.size.height - 50))
        )
    }
}