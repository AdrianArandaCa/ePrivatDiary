//
//  TextFieldAlertModifier.swift
//  ePrivatDiary
//
//  Created by Adrian Aranda Campanario on 9/7/24.
//

import SwiftUI

struct TextFieldAlertPasswordModifier: ViewModifier {
    var viewModel: PageViewModel
    @State var password: String = ""
    @Binding var isPresented: Bool
    let action: (Bool) -> Void
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: isPresented ? 1 : 0)
            
            if isPresented {
                VStack {
                    Text("Introducir contraseña")
                        .font(.headline)
                    SecureField("Contraseña", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    HStack {
                        Button("OK") {
                            viewModel.keyEncryptation = password
                            if password != "" {
                                action(true)
                                isPresented = false
                            } else {
                                action(false)
                                isPresented = false
                            }
                        }
                        .padding()
                        
                        Button("Cancelar") {
                            viewModel.keyEncryptation = ""
                            action(false)
                            isPresented = false
                        }
                        .padding()
                    }
                }
                .padding(8)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .transition(.scale)
                .zIndex(1)
            }
        }
    }
}

extension View {
    func textFieldAlert (isPresented: Binding<Bool>, viewModel: PageViewModel, action: @escaping (Bool) -> Void) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                self.modifier(TextFieldAlertPasswordModifier(viewModel: viewModel, isPresented: isPresented, action: action))
            }
        }
    }
}
