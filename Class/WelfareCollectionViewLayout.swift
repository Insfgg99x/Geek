//
//  WelfareCollectionViewLayout.swift
//  geek
//
//  Created by xgf on 2018/2/23.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit

class WelfareCollectionViewLayout: UICollectionViewFlowLayout {
    private let col:Int = 3
    private var gapy = 0
    private var gapx = 0
    private var colHeights = [CGFloat]()
    private var attributes = [UICollectionViewLayoutAttributes]()
    var heigt:((IndexPath) -> CGFloat)!
    
    override func prepare() {
        super.prepare()
        minimumLineSpacing = 1
        minimumInteritemSpacing = 1
        colHeights = [0,0,0]
        attributes.removeAll()
        for i in 0 ..< collectionView!.numberOfSections {
            for j in 0 ..< collectionView!.numberOfItems(inSection: i) {
                let indexPath = IndexPath.init(item: j, section: i)
                let attribute = layoutAttributesForItem(at: indexPath)
                attributes.append(attribute!)
            }
        }
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let a = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        let voidx = sectionInset.left + sectionInset.right + CGFloat(col - 1) * minimumInteritemSpacing
        let w = (CGFloat(screenwidth) - voidx) / CGFloat(col)
        let h = heigt(indexPath)
        let min = minInfo()
        let x = sectionInset.left + CGFloat(min.1) * (w + minimumInteritemSpacing)
        let y = min.0 + minimumLineSpacing
        a.frame = .init(x: x, y: y, width: w, height: h)
        colHeights[min.1] = a.frame.maxY
        
        return a
    }
    override var collectionViewContentSize: CGSize {
        let max = maxy() + sectionInset.bottom
        return CGSize.init(width: CGFloat(screenwidth), height: max)
    }
    private func maxy() -> CGFloat {
        var tmp:CGFloat = colHeights[0]
        for h in colHeights {
            if h > tmp {
                tmp = h
            }
        }
        return tmp
    }
    private func minInfo() -> (CGFloat, Int) {
        var tmp:CGFloat = colHeights[0]
        var index = 0
        for i in 0 ..< colHeights.count {
            let h = colHeights[i]
            if h < tmp {
                tmp = h
                index = i
            }
        }
        return (tmp,index)
    }
}
