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
    @State private var feedback: Feedback?
    @State private var showPasswordAlert: Bool = false
    
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
                
                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            feedback = .happy
                        }) {
                            Text("😊")
                                .font(.largeTitle)
                                .padding()
                                .background(feedback == .happy ? Color.yellow.opacity(0.3) : Color.clear)
                                .clipShape(Circle())
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                        Button(action: {
                            feedback = .neutral
                        }) {
                            Text("😐")
                                .font(.largeTitle)
                                .padding()
                                .background(feedback == .neutral ? Color.yellow.opacity(0.3) : Color.clear)
                                .clipShape(Circle())
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                        Button(action: {
                            feedback = .sad
                        }) {
                            Text("😢")
                                .font(.largeTitle)
                                .padding()
                                .background(feedback == .sad ? Color.yellow.opacity(0.3) : Color.clear)
                                .clipShape(Circle())
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                    }
                } footer: {
                    Text("* El estado de animo por defecto será neutro")
                }
            }
            .navigationBarItems(trailing:
                                    Button(action: {
                showPasswordAlert.toggle()
            }, label: {
                Text("Crear nota")
            }))
            .navigationBarItems(leading:
                                    Button(action: {
                dismiss()
            }, label: {
                Text("Cerrar")
            }))
            //El modificador .toolbar duplica los botones al mostrarse el popup del password
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Button {
//                        dismiss()
//                    } label: {
//                        Text("Cerrar")
//                    }
//                }
//                
//                ToolbarItem {
//                    Button {
//                        showPasswordAlert = true
//                    } label: {
//                        Text("Crear nota")
//                    }
//                }
//            }
            .textFieldAlert(isPresented: $showPasswordAlert, viewModel: viewModel, action: { success in
                if success {
                    viewModel.createPage(title: title, text: text, feedback: feedback ?? .neutral)
                    dismiss()
                }
            })
            .navigationTitle("Nueva nota")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    CreatePageView(viewModel: .init())
}
