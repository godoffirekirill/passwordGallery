import UIKit
import CoreGraphics



class SecondViewController: UIViewController, AddImageDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var imageDataArray: [ImageData] = []
    var currentImageIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        imageDataArray = retrieveImageData()
    }

    func retrieveImageData() -> [ImageData] {
        if let encodedData = UserDefaults.standard.data(forKey: "ImageDataArrayKey") {
            do {
                let imageDataArray = try JSONDecoder().decode([ImageData].self, from: encodedData)
                return imageDataArray
            } catch {
                print("Error decoding ImageDataArray: \(error)")
            }
        }
        return []
    }

    @IBAction func folderButtonPressed(_ sender: UIButton) {
        guard let galleryViewController = self.storyboard?.instantiateViewController(identifier: "GalleryViewController") as? GalleryViewController else { return }
        self.navigationController?.pushViewController(galleryViewController, animated: true)
    }


    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(identifier: "AddImageViewController") as? AddImageViewController else { return }
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func didAddNewImage() {
            // Handle the addition of a new image, for example, reload your collection view
        imageDataArray = retrieveImageData()

        collectionView.reloadData()
        }

}

extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }

        let imageData = imageDataArray[indexPath.item]
        cell.configure(with: imageData.image, index: indexPath.item)
        cell.delegate = self

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.size.width - 15) / 2
        return CGSize(width: side, height: side)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

extension SecondViewController: CollectionViewCellDelegate {
    func didTapImage(at index: Int) {
        // Handle the tap, for example, navigate to another view controller
        guard let destinationViewController = self.storyboard?.instantiateViewController(identifier: "GalleryViewController") as? GalleryViewController else { return }
        destinationViewController.currentImageIndex = index
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
}

