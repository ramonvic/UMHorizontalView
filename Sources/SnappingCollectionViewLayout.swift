//
//  SnappingCollectionViewLayout.swift
//  UMHorizontalCollectionView
//
//  Created by Ramon Vicente on 18/08/17.
//  Copyright © 2017 Umobi. All rights reserved.
//

import UIKit

public protocol SnappingCollectionViewLayoutDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, cellCenteredAt indexPath: IndexPath)
}

open class SnappingCollectionViewLayout: UICollectionViewFlowLayout {

    weak open var delegate: SnappingCollectionViewLayoutDelegate?

    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset,
                                             withScrollingVelocity: velocity) }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left

        let targetRect = CGRect(x: proposedContentOffset.x,
                                y: 0,
                                width: collectionView.bounds.size.width,
                                height: collectionView.bounds.size.height)

        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)

        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.x
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
                self.delegate?.collectionView(collectionView, layout: self, cellCenteredAt: layoutAttributes.indexPath)
            }
        })



        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
