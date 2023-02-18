//
//  CheckEmail.swift
//  loseamp
//
//  Created by Axente Andrei on 15.02.2023.
//

import Foundation

func isDuplicateNickname(nickname: String) -> Bool {
    let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("users.json")
    
    do {
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        let users = try decoder.decode([UserCredentials].self, from: data)
        
        return users.contains { user in
            return user.nickname == nickname
        }
        
    } catch {
        print("Error reading file: \(error)")
        return false
    }
}






