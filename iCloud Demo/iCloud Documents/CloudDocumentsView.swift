//
//  CloudDocumentsView.swift
//  iCloud Demo
//
//  Created by Wojciech Kulik on 06/02/2021.
//

import SwiftUI

struct CloudDocumentsView: View {
    @ObservedObject var viewModel = CloudDocumentsViewModel()

    var body: some View {
        TextEditor(text: $viewModel.content)
            .padding()
    }
}

struct CloudDocumentsView_Previews: PreviewProvider {
    static var previews: some View {
        CloudDocumentsView()
    }
}
