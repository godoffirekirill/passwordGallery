//
//  ViewControllerModel.swift
//  PasswordGalery
//
//  Created by Кирилл Курочкин on 07.12.2023.
//

import Foundation
import SwiftyKeychainKit

class ViewControllerModel {
    
    var username = Bindable<String>("")
    var password = Bindable<String>("")
    
    
    // /
    //    func getPassword(for username: String) -> String? {
    //            do {
    //     //           let storedPassword = try keychain.get(keychainKey)
    //                return storedPassword
    //            } catch {
    //                print("Error retrieving password from Keychain: \(error)")
    //                return nil
    //            }
    //        }
    //
    //    func validateUser(username: String, password: String) -> Bool {
    //            // Retrieve the stored password for the given username
    //            if let storedPassword = getPassword(for: username) {
    //                // Compare the stored password with the entered password
    //
    //
    //                return storedPassword == password
    //
    //            } else {
    //                // Handle the case where the username is not found
    //                print("Username not found.")
    //                return false
    //            }
    //        }
    //    }
    //
    //
}
