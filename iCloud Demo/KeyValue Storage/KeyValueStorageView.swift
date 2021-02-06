//
//  KeyValueStorageView.swift
//  iCloud Demo
//
//  Created by Wojciech Kulik on 06/02/2021.
//

import SwiftUI

struct KeyValueStorageView: View {
    @ObservedObject var viewModel = KeyValueStorageViewModel()

    var body: some View {
        VStack {
            Toggle("Some Option", isOn: $viewModel.isEnabled)
            Spacer()
        }
        .padding()
    }
}

struct KeyValueStorageView_Previews: PreviewProvider {
    static var previews: some View {
        KeyValueStorageView()
    }
}
