//
//  loseampApp.swift
//  loseamp
//
//  Created by Axente Andrei on 04.02.2023.
//

import SwiftUI

@main
struct loseampApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView{
                RegisterView(keychain: KeychainManager.init(), userCredentials: UserCredentials.init(email: "", password: "", nickname: ""))
            }
        }
    }
}
