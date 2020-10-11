//
//  AFoodViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/23/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class AFoodViewController: UIViewController {
    
    var aFoodCollectionViewModel = AFoodCollectionViewModel()
    let cellsCountInARow = 2
    let offSet: CGFloat = 8.0

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCV()
        updateCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCollection()
        title = aFoodCollectionViewModel.categorie.name
    }
    
    @IBAction func addBtnAction(_ sender: UIBarButtonItem) {
        guard let vc = R.storyboard.admin.createFoodViewController() else { return }
        vc.createFoodViewModel.categorieImgUrl = aFoodCollectionViewModel.categorie.url
        vc.createFoodViewModel.categorieName = aFoodCollectionViewModel.categorie.name
        vc.createFoodViewModel.food.notAlone = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addCV() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(resource: R.nib.aFoodCollectionViewCell), forCellWithReuseIdentifier: R.reuseIdentifier.aFoodCollectionViewCell.identifier)
    }
    
    func updateCollection() {
        aFoodCollectionViewModel.addDocToArray {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.collectionView.reloadData()
            }
        }
    }
}

extension AFoodViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aFoodCollectionViewModel.foodArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.aFoodCollectionViewCell, for: indexPath) else {
            let cell = UICollectionViewCell()
            return cell
        }
        cell.imageView.image = nil
        cell.food = aFoodCollectionViewModel.foodArray[indexPath.row]
        cell.indexPath = indexPath
        cell.delegate = self
        cell.config()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameVC = collectionView.frame
        let widthCell = frameVC.width / CGFloat(cellsCountInARow)
        let heightCell = widthCell
        let spacing = CGFloat(cellsCountInARow + 1) * offSet / CGFloat(cellsCountInARow)
        
        return CGSize(width: widthCell - spacing, height: heightCell - (CGFloat(cellsCountInARow) * offSet))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = R.storyboard.admin.createFoodViewController() else { return }
        vc.createFoodViewModel.categorieImgUrl = aFoodCollectionViewModel.categorie.url
        vc.createFoodViewModel.categorieName = aFoodCollectionViewModel.categorie.name
        vc.createFoodViewModel.food.food = aFoodCollectionViewModel.foodArray[indexPath.row]
        vc.createFoodViewModel.food.notAlone = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AFoodViewController: AFoodCollectionViewCellDelegate {
    func deleteFoodWith(cellIndexPath: IndexPath) {
        let food = aFoodCollectionViewModel.foodArray[cellIndexPath.row]
        aFoodCollectionViewModel.deleteFood(food: food) {
            print(self.aFoodCollectionViewModel.foodArray.count)
            self.aFoodCollectionViewModel.deleteCollection(count: self.aFoodCollectionViewModel.foodArray.count) {
                self.updateCollection()
            }
            self.updateCollection()
        }
    }
}
