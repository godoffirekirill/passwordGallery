//
//  CollectionViewCell.swift
//  PasswordGalery
//
//  Created by Кирилл Курочкин on 14.12.2023.
//

import UIKit
protocol CollectionViewCellDelegate: AnyObject {
    func didTapImage(at index: Int)
}

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate: CollectionViewCellDelegate?
        var cellIndex: Int = 0 // Add this property to keep track of the cell index

        func configure(with image: UIImage?, index: Int) {
            imageView.image = image
            cellIndex = index
            addTapGesture()
        }
    

        private func addTapGesture() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            imageView.addGestureRecognizer(tapGesture)
            imageView.isUserInteractionEnabled = true
        }

        @objc private func handleTap() {
            delegate?.didTapImage(at: cellIndex)
        }
    }
    

