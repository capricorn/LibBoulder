//
//  CheckedOutBookView.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/21/24.
//

import SwiftUI

struct CheckedOutBookView: View {
    let book: CheckedOutBookModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(book.title)
                .font(.title3.bold())
            Text(book.author)
                .padding(.bottom, 8)
            HStack {
                Text("Due \(book.dueDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption.weight(.light))
                Spacer()
                if let libraryId = book.libraryId {
                    Text("\(Image(systemName: "building.columns")) \(libraryId.name)")
                        .font(.caption.weight(.light))
                }
            }
        }
    }
}

#Preview {
    CheckedOutBookView(book: PreviewAssets.jsonCheckedOut.checkedOut.first!)
}
