//
//  UpdatePageView.swift
//  ePrivatDiary
//
//  Created by Adrian Aranda Campanario on 8/7/24.
//

import SwiftUI

struct UpdatePageView: View {
    var viewModel: PageViewModel
    var page: PageModel
    @State private var title: String = ""
    @State private var text: String = ""
    @State private var feedback: Feedback?
    @State private var showPasswordAlert: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("", text: $title, prompt: Text("*Titulo"), axis: .vertical)
                        TextField("", text: $text, prompt: Text("*Texto"), axis: .vertical)
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
                .navigationTitle("Modificar pagina")
                .navigationBarTitleDisplayMode(.large)
                .navigationBarItems(trailing:
                                        Button(action: {
                    showPasswordAlert.toggle()
                }, label: {
                    Text("Modificar nota")
                }))
                .navigationBarItems(leading:
                                        Button(action: {
                    dismiss()
                }, label: {
                    Text("Cerrar")
                }))
                //El modificador .toolbar duplica los botones al mostrarse el popup del password
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button {
//                            dismiss()
//                        } label: {
//                            Text("Cerrar")
//                        }
//                    }
//                    
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button {
//                            showPasswordAlert.toggle()
//                        } label: {
//                            Text("Modificar nota")
//                        }
//                    }
//                }
                
                Button {
                    viewModel.removePage(identifier: page.identifier)
                    dismiss()
                } label: {
                    Text("Eliminar pagina")
                        .foregroundStyle(.gray)
                        .underline()
                }
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .onAppear{
                print("UpdatePageView appeared")
                title = page.title
                feedback = page.feedback
                text = viewModel.decrytationPage(page: page) ?? ""
            }
            .textFieldAlert(isPresented: $showPasswordAlert, viewModel: viewModel, action: { success in
                if success {
                    viewModel.updatePage(identifier: page.identifier, title: title, text: text, feedback: feedback ?? .neutral)
                    dismiss()
                }
            })
        }
    }
}

#Preview {
    UpdatePageView(viewModel: .init(), page: PageModel.init(identifier: UUID(), title: "Title test", text: "Text test", encripted: nil, createdAt: .now, feedback: .happy))
}
