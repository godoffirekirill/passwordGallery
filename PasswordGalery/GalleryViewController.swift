//
//  GalleryViewController.swift
//  PasswordGalery
//
//  Created by Кирилл Курочкин on 07.12.2023.
//

import UIKit
import CoreGraphics

class GalleryViewController: UIViewController {

    @IBOutlet weak var uiImageViewGallerry: UIImageView!
    
    
    @IBOutlet weak var changeCommentTextField: UITextField!
    
    @IBOutlet weak var buttomConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var scrolViewGallery: UIScrollView!
    var imageDataArray: [ImageData] = []
    var currentImageIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        imageDataArray = retrieveImageData()
        displayImage()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func ChangeCommentButtonPressed(_ sender: UIButton) {
        guard imageDataArray.isEmpty == false, currentImageIndex >= 0, currentImageIndex < imageDataArray.count else {
            print("Invalid index or empty array.")
            return
        }

            // Update the comments for the current ImageData
            imageDataArray[currentImageIndex].comments = changeCommentTextField.text?.components(separatedBy: ",") ?? []

            // Optionally, you can save the updated array to UserDefaults here if needed
            if let encodedData = try? JSONEncoder().encode(imageDataArray) {
                UserDefaults.standard.set(encodedData, forKey: "ImageDataArrayKey")
            }

            // Print the updated comments for testing
            print("Updated Comments: \(imageDataArray[currentImageIndex].comments)")
    }
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        navigateToImage(indexDelta: 1)

    }
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        navigateToImage(indexDelta: -1)

    }
    
    func retrieveImageData() -> [ImageData] {
            // Retrieve the encoded data from UserDefaults
            if let encodedData = UserDefaults.standard.data(forKey: "ImageDataArrayKey") {
                // Decode the data into an array of ImageData
                do {
                    let imageDataArray = try JSONDecoder().decode([ImageData].self, from: encodedData)
                    return imageDataArray
                } catch {
                    print("Error decoding ImageDataArray: \(error)")
                }
            }
            return []
        }
    func displayImage() {
        // Check if imageDataArray is not empty and currentImageIndex is within its bounds
        guard imageDataArray.isEmpty == false, currentImageIndex >= 0, currentImageIndex < imageDataArray.count else {
            print("Invalid index or empty array.")
            return
        }

        uiImageViewGallerry.image = imageDataArray[currentImageIndex].image
        // You can also display associated comments here if needed
        let commentsText = imageDataArray[currentImageIndex].comments.joined(separator: ", ")
        changeCommentTextField.text = commentsText

        
        
        print("Comments: \(imageDataArray[currentImageIndex].comments)")
    }
    
    func navigateToImage(indexDelta: Int) {
        currentImageIndex += indexDelta

        // Handle index boundaries to create a looping effect
        if imageDataArray.isEmpty {
            return
        }

        if currentImageIndex >= imageDataArray.count {
            currentImageIndex = 0
        } else if currentImageIndex < 0 {
            currentImageIndex = imageDataArray.count - 1
        }

        displayImage()
    }
 
    
func displayImagesWithComments() {
       // Get the array of images with comments
       let imageDataArray = retrieveImageData()

       // You can now use imageDataArray to display images and comments in your UI
       for imageData in imageDataArray {
           let image = imageData.image
           let comments = imageData.comments
           // Display the image and comments as needed
       }
   }

    
    private func registerForKeyboardNotifications() {
     //   NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

//    @objc private func keyboardWillHide(_ notification: NSNotification) {
//        guard let userInfo = notification.userInfo,
//              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
//              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
//        if notification.name == UIResponder.keyboardWillHideNotification {
//            buttomConstrain.constant = 0
//            print("hide")
//        }else {
//            buttomConstrain.constant = keyboardScreenEndFrame.height
//            scrolViewGallery.contentOffset = CGPoint(x: 0, y: scrolViewGallery.contentSize.height - keyboardScreenEndFrame.height)
//
//        }
//        
//        view.needsUpdateConstraints()
//        
//        UIView.animate(withDuration: animationDuration) {
//            self.view.layoutIfNeeded()
//        }
//    }

    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        if notification.name == UIResponder.keyboardWillHideNotification {
            buttomConstrain.constant = 0
            print("show")

        }else {
            buttomConstrain.constant = keyboardScreenEndFrame.height
       //     scrolViewGallery.contentOffset = CGPoint(x: 0, y: scrolViewGallery.contentSize.height - keyboardScreenEndFrame.height)

        }
        
        view.needsUpdateConstraints()
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
        
    }
}

extension GalleryViewController: UITextFieldDelegate {
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
