
import Foundation
import UIKit




class ImagePickerViewModel {
    var selectedImage = Bindable<UIImage?>(nil)
    var comments: [String] = []

    func handleImagePicked(info: [UIImagePickerController.InfoKey: Any]) {
        var chosenImage = UIImage()

        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            chosenImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            chosenImage = image
        }

        // Set the selected image in the Bindable property
        selectedImage.value = chosenImage
    }
    func addComment(_ comment: String) {
          comments.append(comment)
      }
    func saveImageDataArray() {
            // Create an instance of ImageData and save it to UserDefaults
            let imageData = ImageData(image: selectedImage.value ?? UIImage(), comments: comments)
            var imageDataArray = retrieveImageDataArray()
            imageDataArray.append(imageData)

            if let encodedData = try? JSONEncoder().encode(imageDataArray) {
                UserDefaults.standard.set(encodedData, forKey: "ImageDataArrayKey")
            }

            // Reset the comments array
            comments = []
        }

        func retrieveImageDataArray() -> [ImageData] {
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

}

