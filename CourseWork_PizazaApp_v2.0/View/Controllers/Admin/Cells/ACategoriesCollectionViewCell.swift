//
//  ACategoriesCollectionViewCell.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/20/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class ACategoriesCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    var categorie: Categorie!
    var indexPath: IndexPath!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ai: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //config()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //config()
    }
    
    func config() {
        hide()
        nameLabel.text = categorie.name
        if let url = URL(string: categorie.url) {
            UrlLoaderManager.shared.downloadImage(url: url) { (result) in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    DispatchQueue.main.asyncAfter(deadline: .now() /*+ 0.1*/) {
                        self.imageView.image = image
                        self.show()
                    }
                case .failure(let error):
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self.imageView.image = .remove
                        self.show()
                        print("Cant load human image in TableViewController")
                        print(error)
                    }
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
