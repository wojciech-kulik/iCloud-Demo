//
//  CloudKitRawView.swift
//  iCloud Demo
//
//  Created by Wojciech Kulik on 06/02/2021.
//

import SwiftUI

struct CloudKitRawView: View {
    @ObservedObject var viewModel = CloudKitRawViewModel()

    var body: some View {
        List {
            ForEach(viewModel.items, id: \.self) { item in
                Text("\(item.timestamp, formatter: itemFormatter)")
            }
            .onDelete(perform: viewModel.deleteItems)
        }
        .navigationBarItems(trailing: Button(action: viewModel.addItem) {
            Image(systemName: "plus")
        })
        .onAppear {
            viewModel.fetchItems()
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .medium
    return formatter
}()

struct CloudKitRawView_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitRawView()
    }
}
