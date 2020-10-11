//
//  CategorieCollectionViewCell.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/27/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

protocol CategorieCollectionViewCellDelegate {
    func pushVC(categorie: Categorie)
}

class CategorieCollectionViewCell: UICollectionViewCell {
    
    var delegate: CategorieCollectionViewCellDelegate?
    var aCategoriesViewModel = ACategoriesViewModel()
    //var indexPath: IndexPath!
    //var categorie: Categorie!
    let cellsCountInARow = 2
    let offSet: CGFloat = 8.0

    @IBOutlet weak var anotherCategoriesLabel: UILabel!
    @IBOutlet weak var selfCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addCollectionView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func addCollectionView() {
        selfCollectionView.delegate = self
        selfCollectionView.dataSource = self
        selfCollectionView.register(UINib(resource: R.nib.aCategoriesCollectionViewCell), forCellWithReuseIdentifier: R.reuseIdentifier.aCategoriesCollectionViewCell.identifier)
        anotherCategoriesLabel.text = R.string.localizable.anotherCategoriesLabel()
    }
    
    func config() {
        aCategoriesViewModel.addDocToArray { [weak self] (error) in
            guard let self = self else { return }
            guard error == nil else { print(error?.localizedDescription as Any); return }
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.selfCollectionView.reloadData()
            }
        }
    }
}

extension CategorieCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aCategoriesViewModel.getUsableArray().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.aCategoriesCollectionViewCell, for: indexPath) else {
            let cell = UICollectionViewCell()
            return cell
        }
        cell.imageView.image = nil
        cell.categorie = aCategoriesViewModel.getUsableArray()[indexPath.row]
        cell.indexPath = indexPath
        cell.config()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frameVC = collectionView.frame
        let widthCell = frameVC.width / 2 //1 instead cellCountInRow
        let heightCell = widthCell
        let spacing = CGFloat(cellsCountInARow + 1) * offSet / CGFloat(cellsCountInARow)
        
        return CGSize(width: widthCell - spacing, height: heightCell - (2 * offSet))
        //return CGSize(width: widthCell, height: heightCell)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(aCategoriesViewModel.categorieArray[indexPath.row], " delegate")
        delegate?.pushVC(categorie: aCategoriesViewModel.getUsableArray()[indexPath.row])
    }
}

