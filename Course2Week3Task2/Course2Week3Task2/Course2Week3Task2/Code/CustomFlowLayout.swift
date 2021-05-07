//
//  CustomFlowLayout.swift
//  Course2Week3Task2
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class CustomFlowLayout: UICollectionViewLayout {
 
    private let numberOfColumns = 2
    
    static let xCellPadding: CGFloat = 8
    static let yCellPadding: CGFloat = 8
    
    private var cache : [UICollectionViewLayoutAttributes] = []
    
    private var contentWidth : CGFloat{
        guard let collectionView = collectionView else {
            return 0
        }
        return collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
    }
    
    private var contentHeight : CGFloat = 0

    override var collectionViewContentSize: CGSize{
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else {
            return
        }
      
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let column = yOffset.enumerated().min(by: {
                (a, b) in
                return a.element < b.element
            })!.offset
  
            let indexPath = IndexPath(item: item, section: 0)
          
            let photoHeight = item == 0 ? CGFloat(300) : CGFloat(200)
            let height = CustomFlowLayout.yCellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: CustomFlowLayout.xCellPadding, dy: CustomFlowLayout.yCellPadding)
          
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
          
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
      var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
      for attributes in cache {
        if attributes.frame.intersects(rect) {
          visibleLayoutAttributes.append(attributes)
        }
      }
      return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)  -> UICollectionViewLayoutAttributes? {
      return cache[indexPath.item]
    }
}
