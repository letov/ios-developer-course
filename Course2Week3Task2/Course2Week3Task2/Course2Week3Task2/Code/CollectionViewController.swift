//
//  CollectionViewController.swift
//  Course2Week3Task2
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photos = PhotoProvider().photos()
        let idetifier = String(describing: PhotoCollectionViewCell.self)
        let nib = UINib(nibName: idetifier, bundle: nil)
        self.photosCollectionView.register(nib, forCellWithReuseIdentifier: idetifier)
        self.photosCollectionView.delegate = self
        self.photosCollectionView.dataSource = self
        let customFlowLayout = CustomFlowLayout()
        self.photosCollectionView.setCollectionViewLayout(customFlowLayout, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let edgeInsets = UIEdgeInsets(top: CustomFlowLayout.yCellPadding - statusBarHeight,
                                      left: CustomFlowLayout.xCellPadding,
                                      bottom: CustomFlowLayout.yCellPadding,
                                      right: CustomFlowLayout.xCellPadding)
        self.photosCollectionView.frame = self.view.frame.inset(by: edgeInsets)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.photosCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoCollectionViewCell.self), for: indexPath) as! PhotoCollectionViewCell
        cell.configure(with: self.photos[indexPath.row])
        return cell
    }
    
}
