//
//  CategoriesViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/9/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn
import RealmSwift

class CategoriesViewController: UIViewController {
    
    var refreshControl = UIRefreshControl()
    let cellsCountInARow = 2
    let offSet: CGFloat = 8.0
    let aCategorieViewModel = ACategoriesViewModel()
    let categorieViewModel = CategorieViewModel()

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var categorieIVWidth: NSLayoutConstraint!
    @IBOutlet weak var categorieIVHeight: NSLayoutConstraint!
    @IBOutlet weak var backViewHeight: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categorieIV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCollectionView()
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ohMyyy()
        //print("Не забудь удалить из CategoriesViewController ", #function)
        //try! FileManager.default.removeItem(at:Realm.Configuration.defaultConfiguration.fileURL!)
        showBadge()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
     
    func addCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(resource: R.nib.aCategoriesCollectionViewCell), forCellWithReuseIdentifier: R.reuseIdentifier.aCategoriesCollectionViewCell.identifier)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = UIEdgeInsets(top: 280, left: 0, bottom: 0, right: 0)
        categorieIV.layer.cornerRadius = categorieIV.frame.height / 2
        backImageView.layer.cornerRadius = 10
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
    }
    
    func showAlertWithAction() {
        let alert = UIAlertController(title: R.string.localizable.alertTitle(), message: "nil", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func refresh() {
        reload()
    }
    
    func reload() {
        aCategorieViewModel.addDocToArray { [weak self] (error) in
            guard let self = self else { return }
            guard error == nil else { print(error?.localizedDescription as Any); return}
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                print(#function)
                self.collectionView.reloadData()
            }
        }
    }
    
    private func showBadge() {
        if let items = tabBarController?.tabBar.items {
            items[1].badgeValue = String(SharedFactory.shared.basketViewModel.basketArray.count)
        }
    }
    
    func ohMyyy() {
        SharedFactory.shared.likedFoodViewModel.getUsableLikedFood { (error) in
            if let error = error {
                print(error)
            }
        }
    }
}

extension CategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aCategorieViewModel.categorieArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.aCategoriesCollectionViewCell, for: indexPath) else {
            let cell = UICollectionViewCell()
            return cell
        }
        cell.imageView.image = nil
        cell.categorie = aCategorieViewModel.categorieArray[indexPath.row]
        cell.indexPath = indexPath
        cell.config()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frameVC = collectionView.frame
        let widthCell = frameVC.width / CGFloat(cellsCountInARow) //1 instead cellCountInRow
        let heightCell = widthCell //+ 0.5 *widthCell
        let spacing = CGFloat(cellsCountInARow + 1) * offSet / CGFloat(cellsCountInARow)
        
        return CGSize(width: widthCell - spacing, height: heightCell - (2 * offSet))
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = R.storyboard.simple.foodViewController() else { return }
        //vc
        vc.aFoodCollectionViewModel.categorie = aCategorieViewModel.categorieArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CategoriesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y
        
        let height = max(y, 35)
        backViewHeight.constant = height
        categorieIVHeight.constant = height - 60 //280(backView)-220(categorieIV)
        categorieIVWidth.constant = categorieIVHeight.constant
        categorieIV.layer.cornerRadius = categorieIV.frame.height / 2
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }
}
