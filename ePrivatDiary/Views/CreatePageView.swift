//
//  CreatePageView.swift
//  ePrivatDiary
//
//  Created by Adrian Aranda Campanario on 8/7/24.
//

import SwiftUI

struct CreatePageView: View {
    @Environment(\.dismiss) private var dismiss
    var viewModel: PageViewModel
    @State private var title = ""
    @State private var text = ""
    @State private var feedback: Feedback = .neutral
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("", text: $title, prompt: Text("*Titulo"), axis: .vertical)
                        .accessibilityIdentifier("createnote_title_identifier")
                    TextField("", text: $text, prompt: Text("*Texto"), axis: .vertical)
                        .accessibilityIdentifier("createnote_text_identifier")
                } footer: {
                    Text("* El titulo es obligatorio")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cerrar")
                    }
                }
                
                ToolbarItem {
                    Button {
                        viewModel.createPage(title: title, text: text, feedback: feedback)
                        dismiss()
                    } label: {
                        Text("Crear nota")
                    }
                }
            }
            .navigationTitle("Nueva nota")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    CreatePageView(viewModel: .init())
}
