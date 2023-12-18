
import Foundation
import UIKit

class ImageData: Codable {
    var image: UIImage
    var comments: [String]

    init(image: UIImage, comments: [String]) {
        self.image = image
        self.comments = comments
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let imageData = try container.decode(Data.self, forKey: .image)

        if let decodedImage = UIImage(data: imageData) {
            image = decodedImage
        } else {
            throw DecodingError.dataCorruptedError(forKey: .image, in: container, debugDescription: "Failed to decode UIImage")
        }

        comments = try container.decode([String].self, forKey: .comments)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(image.jpegData(compressionQuality: 1.0), forKey: .image)
        try container.encode(comments, forKey: .comments)
    }

    private enum CodingKeys: String, CodingKey {
        case image
        case comments
    }
}
