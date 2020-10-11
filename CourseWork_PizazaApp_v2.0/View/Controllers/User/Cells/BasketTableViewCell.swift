//
//  BasketTableViewCell.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 10/1/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

protocol BasketTableViewCellDelegate {
    func changeCount(elementWith indexPath: IndexPath, onNumber: Int)
}

class BasketTableViewCell: UITableViewCell {
    
    var delegate: BasketTableViewCellDelegate?
    var indexPath: IndexPath!
    var basketElement: BasketElement!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var productCountLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var ai: UIActivityIndicatorView!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func plusBtnAction(_ sender: UIButton) {
        minusBtn.isEnabled = true
        delegate?.changeCount(elementWith: indexPath, onNumber: 1)
        productCountLabel.text = String(basketElement.count)
    }
    
    @IBAction func minusBtnAction(_ sender: UIButton) {
        delegate?.changeCount(elementWith: indexPath, onNumber: -1)
        makeBtnEnabled()
        productCountLabel.text = String(basketElement.count)
    }
    
    func config() {
        makeBtnEnabled()
        hide(true)
        if let url = URL(string: basketElement.url) {
            UrlLoaderManager.shared.downloadImage(url: url) { (result) in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    DispatchQueue.main.asyncAfter(deadline: .now() /*+ 0.1*/) {
                        self.foodImageView.image = image
                        self.hide(false)
                    }
                case .failure(let error):
                    self.foodImageView.image = .remove
                    self.hide(false)
                    print("Cant load human image in TableViewController")
                    print(error)
                }
            }
        }
    }
    
    private func hide(_ bool: Bool) {
        foodImageView.isHidden = bool
        nameLabel.isHidden = bool
        costLabel.isHidden = bool
        caloriesLabel.isHidden = bool
        productCountLabel.isHidden = bool
        minusBtn.isHidden = bool
        plusBtn.isHidden = bool
        ai.isHidden = !bool
        if !bool {
            ai.stopAnimating()
            nameLabel.text = basketElement.name
            costLabel.text = String(basketElement.cost.rounded(place: 2)) + " " + R.string.localizable.br()
            caloriesLabel.text = String(basketElement.calories.rounded(place: 2)) + " " + basketElement.cu
            productCountLabel.text = String(basketElement.count)
        }
        if bool {
            ai.startAnimating()
            foodImageView.image = nil
        }
    }
    
    private func makeBtnEnabled() {
        if basketElement.count == 1 {
            minusBtn.isEnabled = false
        }
    }
}
