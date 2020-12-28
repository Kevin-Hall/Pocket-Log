//
//  FeedGrid.swift
//  Journal
//
//  Created by Kevin Hall on 6/7/18.
//  Copyright © 2018 Kevin Hall. All rights reserved.
//

import UIKit

class GridLayout: UICollectionViewFlowLayout {
    
    
    let innerSpace: CGFloat = 22
    var numberOfCellsOnRow: CGFloat = 2
    
    override init() {
        super.init()
        self.minimumLineSpacing = innerSpace
        self.minimumInteritemSpacing = innerSpace
        self.scrollDirection = .vertical

    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    func itemWidth() -> CGFloat {
        return (collectionView!.frame.size.width/self.numberOfCellsOnRow)-self.innerSpace
    }
    
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width:itemWidth(), height:215)
        }
        get {
            return CGSize(width:itemWidth(),height:215)
        }
    }
    
}

