//
//  AFoodCollectionViewCell.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/23/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

protocol AFoodCollectionViewCellDelegate {
    func deleteFoodWith(cellIndexPath: IndexPath)
}

class AFoodCollectionViewCell: UICollectionViewCell {
    
    var food: Food!
    var indexPath: IndexPath!
    var delegate: AFoodCollectionViewCellDelegate?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ai: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func deleteBtn(_ sender: UIButton) {
        delegate?.deleteFoodWith(cellIndexPath: indexPath)
    }
    
    func config() {
        hide()
        nameLabel.text = food.name
        if let url = URL(string: food.url) {
            UrlLoaderManager.shared.downloadImage(url: url) { (result) in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        self.imageView.image = image
                        self.show()
                    })
                case .failure(let error):
                    print("Cant load human image in TableViewController")
                    print(error)
                }
            }
        }
    }
    
    private func hide() {
        imageView.isHidden = true
        ai.isHidden = false
        ai.startAnimating()
    }
    
    private func show() {
        ai.isHidden = true
        ai.stopAnimating()
        imageView.isHidden = false
    }
}
