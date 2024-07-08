//
//  ContentView.swift
//  ePrivatDiary
//
//  Created by Adrian Aranda Campanario on 7/7/24.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel: PageViewModel = .init()
    @State private var showCreateNote = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.pages) { pages in
                    NavigationLink(value: pages) {
                        VStack(alignment: .leading) {
                            Text(pages.title)
                                .foregroundStyle(.primary)
                            Text(pages.getDate())
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .status) {
                    Button(action: {
                        showCreateNote.toggle()
                    }, label: {
                        Label("Crear pagina", systemImage: "square.and.pencil")
                            .labelStyle(TitleAndIconLabelStyle())
                    })
                    .buttonStyle(.bordered)
                    .tint(.blue)
                    .bold()
                }
            }
            .navigationTitle("Paginas")
            .navigationDestination(for: PageModel.self, destination: { page in
                UpdatePageView(viewModel: viewModel, identifier: page.identifier, title: page.title, text: page.text ?? "")
            })
            .fullScreenCover(isPresented: $showCreateNote, content: {
                CreatePageView(viewModel: viewModel)
            })
        }
    }
}

#Preview {
    ContentView()
}
