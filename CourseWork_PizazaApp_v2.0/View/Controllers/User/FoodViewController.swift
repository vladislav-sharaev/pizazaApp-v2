//
//  FoodViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/28/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController {
    
    var aFoodCollectionViewModel = AFoodCollectionViewModel()
    let cellsCountInARow = 2
    let offSet: CGFloat = 8.0
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ai: UIActivityIndicatorView!
    
    //custom nav view
    @IBOutlet weak var customNavView: UIView!
    @IBOutlet weak var customNavViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var categorieNameLabel: UILabel!
    @IBOutlet weak var categorieNameLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var categorieNameLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var categorieNameLabelLeading: NSLayoutConstraint!
    
    @IBOutlet weak var foodCountLabel: UILabel!
    @IBOutlet weak var foodCountLabelHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reload()
        addCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func backNavC(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func addCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(resource: R.nib.categorieCollectionViewCell), forCellWithReuseIdentifier: R.reuseIdentifier.categorieCollectionViewCell.identifier)
        collectionView.register(UINib(resource: R.nib.foodCategorieCollectionViewCell), forCellWithReuseIdentifier: R.reuseIdentifier.foodCategorieCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0)
        
        //for navigation bar
//        title = aFoodCollectionViewModel.categorie.name
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .always
        
        //for others
        categorieNameLabel.text = aFoodCollectionViewModel.categorie.name
    }

    func reload() {
        ai.startAnimating()
        ai.isHidden = false
        aFoodCollectionViewModel.addDocToArray {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.ai.isHidden = true
                self.ai.stopAnimating()
                self.foodCountLabel.text = String(self.aFoodCollectionViewModel.foodArray.count) + R.string.localizable.foodCountLabel()
                self.collectionView.reloadData()
            }
        }
    }
    
    func pushFoodVC(categorie: Categorie) {
        guard let vc = R.storyboard.simple.foodViewController() else { return }
        //vc
        vc.aFoodCollectionViewModel.categorie = categorie
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FoodViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aFoodCollectionViewModel.foodArrayCountPlusOne
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == aFoodCollectionViewModel.foodArray.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.categorieCollectionViewCell, for: indexPath) else {
                let cell = UICollectionViewCell()
                return cell
            }
            //cell.imageView.image = nil
            cell.aCategoriesViewModel.categorie = aFoodCollectionViewModel.categorie
            //cell.indexPath = indexPath
            cell.config()
            cell.delegate = self
            return cell

        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.foodCategorieCollectionViewCell, for: indexPath) else {
                let cell = UICollectionViewCell()
                return cell
            }
            cell.categorie = aFoodCollectionViewModel.categorie.name
            cell.imageView.image = nil
            cell.food = aFoodCollectionViewModel.foodArray[indexPath.row]
            cell.indexPath = indexPath
            cell.config()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frameVC = collectionView.frame
        
        if indexPath.row == aFoodCollectionViewModel.foodArray.count {
            let widthCell = frameVC.width
            let heightCell = widthCell / 1.5
            let spacing = CGFloat(cellsCountInARow) * offSet// / CGFloat(cellsCountInARow)
            return CGSize(width: widthCell - spacing, height: heightCell - (2 * offSet))
        } else {
            let widthCell = frameVC.width / CGFloat(cellsCountInARow) //1 instead cellCountInRow
            let heightCell = widthCell * 1.3 //+ 0.3 * widthCell
            let spacing = CGFloat(cellsCountInARow + 1) * offSet / CGFloat(cellsCountInARow)

            return CGSize(width: widthCell - spacing, height: heightCell - (2 * offSet))
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = R.storyboard.simple.oneFoodViewController() else { return }
        //vc
        vc.oneFoodViewModel.food = aFoodCollectionViewModel.foodArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FoodViewController: CategorieCollectionViewCellDelegate {
    func pushVC(categorie: Categorie) {
        pushFoodVC(categorie: categorie)
    }
}

extension FoodViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y
        let height = max(y, 40)
        customNavViewHeight.constant = height
        if 160 - y < 60 {
            categorieNameLabelLeading.constant = 160 - y
        }
        if 160 - y < 11 {
            categorieNameLabelLeading.constant = 10
        }
        if 350 - y > 200 && 350 - y < 300{
            categorieNameLabelWidth.constant = 350 - y
        }
        categorieNameLabelHeight.constant = height
        foodCountLabelHeight.constant = y - 125
    }
}
