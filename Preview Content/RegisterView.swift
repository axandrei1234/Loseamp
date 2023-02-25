//
//  RegisterParams.swift
//  loseamp
//
//  Created by Axente Andrei on 04.02.2023.
//


import SwiftUI
import UIKit


struct RegisterView: View {
    
    @State private var toggle = false
    @State private var showAlert = false
    @State private var Message = ""
    @State private var loseamp: String = "loseamp"
    @State private var isPresented = false
    @FocusState private var fieldIsFocused: Bool
    @State private var showDuplicateNickname = false
    @State private var showDuplicateEmail = false
    @State private var isSecured: Bool = true
    @State private var showReq: Bool = true
    @State var keychain: KeychainManager
    @State var userCredentials: UserCredentials
    @State var checked = false
    
    var alert: Alert {
        Alert(title: Text(Message), dismissButton: .default(Text("OK")))
    }
    
    var body: some View {
        NavigationView {
            VStack{
                NavigationLink(destination: LoginView(), label: {
                    Label("Login", systemImage: "chevron.backward")
                    
                })
                .position(x:70,y:10)
                
                
                Form{
                    Label("What's your email", systemImage: "at")
                        .bold()
                    TextField("email", text: $userCredentials.email)
                        .focused($fieldIsFocused)
                    if showDuplicateEmail {
                        Text("There already exists an account with this email.")
                            .foregroundColor(.red)
                    }
                    ZStack(alignment: .trailing){
                        HStack{
                            Label("Enter a new password", systemImage: "lock")
                                .bold()
                            Button(action: {
                                showReq.toggle()
                            }) {Image(systemName: "questionmark")
                                    .accentColor(.blue)
                            }
                        }
                    }
                    ZStack(alignment: .trailing){
                        Group {
                            if isSecured {
                                SecureField("password", text: $userCredentials.password)
                            } else {
                                TextField("password", text: $userCredentials.password)
                            }
                            Button(action: {
                                isSecured.toggle()
                            }) {
                                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                                    .accentColor(.gray)
                            }
                        }
                    }
                    Label("Tell us your nickname", systemImage: "person")
                        .bold()
                    TextField("nickname", text: $userCredentials.nickname)
                        .focused($fieldIsFocused)
                    if showDuplicateNickname {
                        Text("That nickname is taken. Please choose another.")
                            .foregroundColor(.red)
                    }
                    if showReq {
                        Text("Password Requirements: \n8-40 characters\nOne capital character\nOne alphabet character")
                    } else {
                        Text("")
                    }
                }
                
                .scrollContentBackground(.hidden)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .frame(width: 400, height: 530)
                
                HStack {
                    Image(systemName: checked ? "checkmark.square.fill" : "square")
                        .foregroundColor(checked ? Color(uiColor: .systemBlue):Color.secondary)
                        .onTapGesture {
                            self.checked.toggle()
                        }
                    Text("Terms and conditions (OPTIONAL)")
                }
                .position(x:155)
                Button ("Sign Up") {
                    showDuplicateEmail = false
                    showDuplicateNickname = false
                    if (!isValidEmailAddr(strToValidate: userCredentials.email) || !isValidPassword(strToVailidate: userCredentials.password)) {
                        Message = "mail or password are incorrect"
                        self.showAlert.toggle()
                    }
                    if (isDuplicateNickname(nickname: userCredentials.nickname)) {
                        fieldIsFocused = true
                        showDuplicateNickname = true
                    }
                    if ((keychain.isDuplicateEmail(account: userCredentials.email) == true) && isValidEmailAddr(strToValidate: userCredentials.email)) {
                        fieldIsFocused = true
                        showDuplicateEmail = true
                    }
                    
                    if (isValidEmailAddr(strToValidate: userCredentials.email) && isValidPassword(strToVailidate: userCredentials.password) && !keychain.isDuplicateEmail(account: userCredentials.email) && !isDuplicateNickname(nickname: userCredentials.nickname)) {
                        print("Email Password, and Nickname are valid")
                        save(account: userCredentials.email, password: userCredentials.password)
                        saveJSON(email: userCredentials.email, nickname: userCredentials.nickname)
                        Message = "account created succesfully"
                        self.showAlert.toggle()
                    }
                }
                .alert(isPresented: $showAlert, content: { self.alert })
                .font(.title)
                .buttonStyle(.bordered)
                .frame(width:150, height: 100)
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            
        }
        
        
        .background(.white)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(keychain: KeychainManager.init(), userCredentials: UserCredentials.init(email: "", password: "", nickname: ""))
    }
}
