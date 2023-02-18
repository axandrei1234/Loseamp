//
//  OnRegisterAction.swift
//  loseamp
//
//  Created by Axente Andrei on 12.02.2023.
//

import Foundation  // acest file nu i folosit la nimic (era pe vremea cand voiam sa salvez tot in json)

var users = loadJSON()

func saveJSON (email: String, nickname: String) {
    let newUsers = UserCredentials(email: email, nickname: nickname)
    users.append(newUsers)
    
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    
    do {
        let data = try encoder.encode(users)
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("users.json")
        print(url.path)
        try data.write(to: url)
    } catch {
        print("Error encoding JSON: \(error)")
    }
}

func loadJSON () -> [UserCredentials] {
    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("users.json")
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let users = try decoder.decode([UserCredentials].self, from: data)
        return users
    } catch {
        print("Error reading file: \(error)")
        return []
    }
}
