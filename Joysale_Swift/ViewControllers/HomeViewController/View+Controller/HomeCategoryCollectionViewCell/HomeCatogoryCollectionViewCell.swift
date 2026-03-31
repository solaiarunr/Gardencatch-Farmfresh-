//
//  HomeCatogoryCollectionViewCell.swift
//  Joysale_Swift
//
//  Created by Hitasoft on 15/06/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class HomeCatogoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var categoryData = [CategoryModel]()
    var homeVC: HomeViewController?
    var ADviewType = String()
     var from_page = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        
          // Initialization code
    }
    func configUI() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
    }
    func loadCategoryData(_ categoryData: [CategoryModel]) {
        self.categoryData = categoryData
        self.collectionView.reloadData()
    }
}
extension HomeCatogoryCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        if from_page{
            cell.categoryImageView.isHidden = true
            cell.backgroundColor = chat_bg
            cell.categoryNameLabel.textColor = .white
            
        }
        cell.loadData(categoryData[indexPath.row], viewType: true)
        cell.categoryImageView.layer.cornerRadius = 25
        cell.categoryImageView.clipsToBounds = true
        cell.categoryImageView.contentMode = .scaleToFill
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeVC?.selectedCategoryAct(indexPath.row)
    }
}
