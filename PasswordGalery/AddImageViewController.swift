

import UIKit

protocol AddImageDelegate: AnyObject {
    func didAddNewImage()
}


class AddImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var uiimageView: UIImageView!
    
    @IBOutlet weak var enterCommentUitextField: UITextField!
    
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var buttomConstrain: NSLayoutConstraint!
    
    let imagePickerViewModel = ImagePickerViewModel()

    weak var delegate: AddImageDelegate?
    
    override func viewDidLoad() {
            super.viewDidLoad()
            registerForKeyboardNotifications()

            imagePickerViewModel.selectedImage.bind { [weak self] image in
                self?.uiimageView.image = image
            }
        }
    

        @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            // Move the image picking logic to the ViewModel
            imagePickerViewModel.handleImagePicked(info: info)

            // Dismiss the picker
            picker.dismiss(animated: true)
        }

        @IBAction func addGalleryButtonPressed(_ sender: UIButton) {
            // Do something with the selected image, if needed
            
            let comment = enterCommentUitextField.text ?? ""
                  imagePickerViewModel.addComment(comment)
                  imagePickerViewModel.saveImageDataArray()

                  // Update the imageDataArray in GalleryViewController
                  if let galleryViewController = presentingViewController as? GalleryViewController {
                      galleryViewController.imageDataArray = imagePickerViewModel.retrieveImageDataArray()
                      galleryViewController.currentImageIndex = galleryViewController.imageDataArray.count - 1
                      galleryViewController.displayImage()
                  }

              // Clear the comment field if needed
            delegate?.didAddNewImage()
              enterCommentUitextField.text = ""
        }

        @IBAction func exitButtonPressed(_ sender: UIButton) {
            self.navigationController?.popViewController(animated: true)
        }

        private func registerForKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }

        @objc private func keyboardWillShow(_ notification: NSNotification) {
            guard let userInfo = notification.userInfo,
                  let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
                  let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            if notification.name == UIResponder.keyboardWillHideNotification {
                buttomConstrain.constant = 0
            } else {
                buttomConstrain.constant = keyboardScreenEndFrame.height + 10
                scrolView.contentOffset = CGPoint(x: 0, y: scrolView.contentSize.height - keyboardScreenEndFrame.height)
            }

            view.needsUpdateConstraints()

            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }

    extension AddImageViewController: UITextFieldDelegate {

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            view.endEditing(true)
            return true
        }
    }
