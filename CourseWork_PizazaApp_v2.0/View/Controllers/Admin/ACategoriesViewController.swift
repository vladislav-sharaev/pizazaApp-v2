//
//  ACategoriesViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/20/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class ACategoriesViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let cellsCountInARow = 2
    let offSet: CGFloat = 8.0
    var aCategoriesViewModel = ACategoriesViewModel()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCollectionView()
        configLocalication()
        setupLongGestureRecognizerOnCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateComplteion()
    }
    
    @IBAction func addNewAction(_ sender: UIBarButtonItem) {
    }
    
    func addCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(resource: R.nib.aCategoriesCollectionViewCell), forCellWithReuseIdentifier: R.reuseIdentifier.aCategoriesCollectionViewCell.identifier)
    }
    
    func configLocalication() {
        self.title = R.string.localizable.navTitleACategories()
    }
    
    func updateComplteion() {
        aCategoriesViewModel.addDocToArray { [weak self] (error) in
            guard let self = self else { return }
            guard error == nil else { print(error?.localizedDescription as Any); return}
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self.collectionView.reloadData()
            })
        }
    }
    
    //MARK: - Long press gesture -
    
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 1
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        collectionView?.addGestureRecognizer(longPressedGesture)
        
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }
        let p = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView?.indexPathForItem(at: p) {
            guard let vc = R.storyboard.admin.editCategorieViewController() else { return }
            vc.editCategorieViewModel.categorie = aCategoriesViewModel.categorieArray[indexPath.row]
            vc.editCategorieViewModel.url = aCategoriesViewModel.categorieArray[indexPath.row].url
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ACategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aCategoriesViewModel.categorieArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.aCategoriesCollectionViewCell, for: indexPath) else {
            let cell = UICollectionViewCell()
            return cell
        }
        cell.imageView.image = nil
        cell.categorie = aCategoriesViewModel.categorieArray[indexPath.row]
        cell.indexPath = indexPath
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
        guard let vc = R.storyboard.admin.aFoodViewController() else { return }
        //vc
        vc.aFoodCollectionViewModel.categorie = aCategoriesViewModel.categorieArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
