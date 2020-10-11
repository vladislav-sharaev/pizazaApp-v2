//
//  FoodCategorieCollectionViewCell.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/28/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

protocol FoodCategorieCollectionViewCellDelegate {
    func updateCollection()
}

class FoodCategorieCollectionViewCell: UICollectionViewCell {
    
    var indexPath: IndexPath!
    var food: Food!
    var categorie: String!
    var delegate: FoodCategorieCollectionViewCellDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var ai: UIActivityIndicatorView!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    @IBAction func likeButtonAction(_ sender: UIButton) {
        self.updateButtonImage()
        SharedFactory.shared.likedFoodViewModel.likeUnlike(food: food) { (error) in
            if let error = error {
                print(error)
            } else {
                self.delegate?.updateCollection()
            }
        }
    }
    
    func config() {
        hide(true)
        if let url = URL(string: food.url) {
            UrlLoaderManager.shared.downloadImage(url: url) { (result) in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    DispatchQueue.main.asyncAfter(deadline: .now() /*+ 0.1*/) {
                        self.imageView.image = image
                        self.hide(false)
                    }
                case .failure(let error):
                    self.imageView.image = .remove
                    self.hide(false)
                    print("Cant load human image in TableViewController")
                    print(error)
                }
            }
        }
    }
    
    func hide(_ bool: Bool) {
        self.configButtonImage()
        imageView.isHidden = bool
        nameLabel.isHidden = bool
        costLabel.isHidden = bool
        caloriesLabel.isHidden = bool
        ai.isHidden = !bool
        if !bool {
            ai.stopAnimating()
            nameLabel.text = food.name
            costLabel.text = String(food.maxCost.rounded(place: 2)) + " " + R.string.localizable.br()
            caloriesLabel.text = String(food.maxCalories.rounded(place: 2)) + " " + food.cu
        }
        if bool {
            ai.startAnimating()
            imageView.image = nil
        }
    }
    
    private func updateButtonImage() {
        if likeButton.imageView?.image == UIImage(systemName: "heart") {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    private func configButtonImage() {
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        for element in SharedFactory.shared.likedFoodViewModel.usableLikedFoodArray {
            if element.name == food.name {
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }
    }
}


//heart
//heart.fill
