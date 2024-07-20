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
    @State var showPasswordAlert = false
    @State var showUpdatePage = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.pages) { page in
                    Button(action: {
                        viewModel.selectedPage = page
                        showPasswordAlert = true
                    }) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(page.title)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if page.feedback == .happy {
                                    Text("😀")
                                }  else if page.feedback == .neutral {
                                    Text("😐")
                                } else if page.feedback == .sad {
                                    Text("😢")
                                }
                            }
                            Text(page.getDate())
                                .foregroundStyle(.secondary)
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button(action: {
                            viewModel.removePage(identifier: page.identifier)
                        }, label: {
                            Label("Borrar", systemImage: "trash.fill")
                        })
                        .tint(.red)
                    }
                }
            }
            .textFieldAlert(isPresented: $showPasswordAlert, viewModel: viewModel, action: { success in
                if success {
                    showPasswordAlert = false
                    showUpdatePage = true
                } else {
                    showUpdatePage = false
                }
            })
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
            .fullScreenCover(isPresented: $showUpdatePage, content: {
                if let page = viewModel.selectedPage {
                    UpdatePageView(viewModel: viewModel, page: page)
                } else {
                    EmptyView()
                }
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
