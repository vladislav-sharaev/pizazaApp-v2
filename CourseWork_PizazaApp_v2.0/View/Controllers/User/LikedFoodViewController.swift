//
//  LikedFoodViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 10/8/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class LikedFoodViewController: UIViewController {
    
    var likedFoodViewModel = LikedFoodViewModel()
    let cellsCountInARow = 2
    let offSet: CGFloat = 8.0

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCollectionView()
        configLocalization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    func configLocalization() {
        title = R.string.localizable.selectedProductsTitle()
    }
    
    func addCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(resource: R.nib.foodCategorieCollectionViewCell), forCellWithReuseIdentifier: R.reuseIdentifier.foodCategorieCollectionViewCell.identifier)
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension LikedFoodViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SharedFactory.shared.likedFoodViewModel.usableLikedFoodArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.foodCategorieCollectionViewCell, for: indexPath) else {
            let cell = UICollectionViewCell()
            return cell
        }
        cell.imageView.image = nil
        cell.food = SharedFactory.shared.likedFoodViewModel.usableLikedFoodArray[indexPath.row]
        cell.indexPath = indexPath
        cell.config()
        cell.delegate = self
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frameVC = collectionView.frame
        let widthCell = frameVC.width / CGFloat(cellsCountInARow) //1 instead cellCountInRow
        let heightCell = widthCell * 1.3 //+ 0.3 * widthCell
        let spacing = CGFloat(cellsCountInARow + 1) * offSet / CGFloat(cellsCountInARow)

        return CGSize(width: widthCell - spacing, height: heightCell - (2 * offSet))
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = R.storyboard.simple.oneFoodViewController() else { return }
        //vc
        vc.oneFoodViewModel.food = SharedFactory.shared.likedFoodViewModel.usableLikedFoodArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LikedFoodViewController:  FoodCategorieCollectionViewCellDelegate {
    func updateCollection() {
        reload()
    }
}
