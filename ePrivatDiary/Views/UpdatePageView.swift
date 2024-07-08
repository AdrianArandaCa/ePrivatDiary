//
//  UpdatePageView.swift
//  ePrivatDiary
//
//  Created by Adrian Aranda Campanario on 8/7/24.
//

import SwiftUI

struct UpdatePageView: View {
    var viewModel: PageViewModel
    var identifier: UUID
    @State var title: String = ""
    @State var text: String = ""
    @State var feedback: Feedback = .neutral
    @Environment(\.dismiss) private var dismiss

        var body: some View {
            VStack {
                Form {
                    Section {
                        TextField("", text: $title, prompt: Text("*Titulo"), axis: .vertical)
                        TextField("", text: $text, prompt: Text("*Texto"), axis: .vertical)   
                    }
                }
                Button {
                    viewModel.removePage(identifier: identifier)
                    dismiss()
                } label: {
                    Text("Eliminar pagina")
                        .foregroundStyle(.gray)
                        .underline()
                }
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .toolbar {
                ToolbarItem {
                    Button {
                        viewModel.updatePage(identifier: identifier, title: title, text: text, feedback: feedback)
                    } label: {
                        Text("Guardar pagina")
                    }
                }
            }
            .navigationTitle("Modificar pagina")
        }
}

#Preview {
    UpdatePageView(viewModel: .init(), identifier: .init(), title: "Titulo modificado", text: "Texto de la pagina modificado por completo", feedback: .happy)
}
