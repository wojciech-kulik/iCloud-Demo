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
                Text("\(item.timestamp, formatter: .itemFormatter)")
            }
            .onDelete(perform: viewModel.deleteItems)
        }
        .navigationBarItems(trailing: HStack {
            Button(action: viewModel.fetchItems) {
                Image(systemName: "arrow.clockwise")
            }
            Button(action: viewModel.addItem) {
                Image(systemName: "plus")
            }
        })
        .onAppear {
            viewModel.fetchItems()
        }
    }
}

struct CloudKitRawView_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitRawView()
    }
}
