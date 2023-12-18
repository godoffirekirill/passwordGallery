import Foundation
import UIKit
import SwiftyKeychainKit
class CreatePassViewControllerModel {
    // Bindable properties for login, password, and rePassword
    var login = Bindable<String>("")
    var password = Bindable<String>("")
    var rePassword = Bindable<String>("")
    
    let keychain = Keychain(service: "Pass") // Keychain for password
    let keychainKey = KeychainKey<String>(key: "pass") // Key for password
    
    let keychainUser = Keychain(service: "Log") // Keychain for username
    let usernameKey = KeychainKey<String>(key: "log") // Key for username
    
    var username = Bindable<String>("")
    var userpass = Bindable<String>("")
    
    init() {
        
    }
    
    // Function to handle create button tap
    func createButtonTapped() {
        // Access login, password, and rePassword values from the bindable properties
        let loginValue = login.value
        let passwordValue = password.value
        let rePasswordValue = rePassword.value
        
        guard passwordValue == rePasswordValue else {
            print("Passwords do not match.")
            return
        }
        
        // Check if password is at least 8 characters
        guard passwordValue.count >= 8 else {
            print("Password is less than 8 characters.")
            return
        }
        
        // Validate other data if needed (add your validation logic here)
        
        // Save data to Keychain using SwiftyKeychainKit
        do {
            try keychain.set(passwordValue, for: keychainKey)
            try keychainUser.set(loginValue, for: usernameKey)
            
            print("Data saved to Keychain")
        } catch {
            print("Error saving data to Keychain: \(error)")
        }
    }
    
    func getCredentials() -> (String, String)? {
        do {
            // Retrieve the stored username and password from Keychain
            let storedUsername = try keychainUser.get(usernameKey)
            let storedPassword = try keychain.get(keychainKey)
            
            return (storedUsername, storedPassword) as? (String, String)
        } catch {
            print("Error retrieving credentials from Keychain: \(error)")
            return nil
        }
    }
    
    func validateUser(username: String, password: String) -> Bool {
        // Retrieve the stored username and password from Keychain
        if let (storedUsername, storedPassword) = getCredentials() {
            // Compare the stored username and password with the entered values
            return storedUsername == username && storedPassword == password
        } else {
            // Handle the case where the credentials are not found
            print("Credentials not found.")
            return false
        }
    }
}
