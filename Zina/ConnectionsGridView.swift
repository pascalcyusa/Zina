import SwiftUI

struct ConnectionsGridView: View {
    let people: [Person]
    let onPersonSelected: (Person) -> Void
    
    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(people) { person in
                    PersonCard(
                        person: person,
                        people: people,
                        onEdit: { selectedPerson in
                            onPersonSelected(selectedPerson)
                        }
                    )
                }
            }
            .padding()
        }
    }
}