//
//  UMHorizontalView.swift
//  UMHorizontalCollectionView
//
//  Created by Ramon Vicente on 18/08/17.
//  Copyright © 2017 Umobi. All rights reserved.
//

import UIKit

@objc
public protocol UMHorizontalViewDataSource: NSObjectProtocol {

    @objc(numberOfItemsInHorizontalView:)
    func numberOfItems(in horizontalView: UMHorizontalView) -> Int

    func horizontalView(_ horizontalView: UMHorizontalView, cellForItemIn collectionView: UICollectionView, at indexPath: IndexPath) -> UMHorizontalViewCell
}

@objc
public protocol UMHorizontalViewDelegate: NSObjectProtocol {

    @objc
    optional func horizontalView(_ horizontalView: UMHorizontalView, didSelectItemIn collectionView: UICollectionView, at indexPath: IndexPath)

    @objc
    optional func horizontalView(_ horizontalView: UMHorizontalView, didDeselectItemIn collectionView: UICollectionView, at indexPath: IndexPath)
}

open class UMHorizontalViewCell: UICollectionViewCell {

}

open class UMHorizontalView: UIView {

    weak open var delegate: UMHorizontalViewDelegate?

    weak open var dataSource: UMHorizontalViewDataSource?

    open var pageIndicatorTintColor: UIColor?
    open var currentPageIndicatorTintColor: UIColor?

    open var itemsPerPage: CGFloat = 1
    open var itemsSpacing: CGFloat = 10

    lazy var collectionView: UICollectionView = {
        let layout = SnappingCollectionViewLayout()
        layout.minimumLineSpacing = self.itemsSpacing
        layout.scrollDirection = .horizontal
        layout.delegate = self

        let width = self.frame.size.width-(self.itemsSpacing * (self.itemsPerPage-1))/self.itemsPerPage
        layout.itemSize = CGSize(width: width, height: self.frame.size.height)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast

        collectionView.register(UMHorizontalViewCell.self, forCellWithReuseIdentifier: "cell")

        self.addSubview(collectionView)

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[collectionView]-0-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil,
                                                           views: ["collectionView": collectionView]))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil,
                                                           views: ["collectionView": collectionView]))

        return collectionView
    }()

    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(pageControl)
        self.bringSubview(toFront: pageControl)


        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[pageControl]-0-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil,
                                                           views: ["pageControl": pageControl]))


        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[pageControl(20)]-5-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil,
                                                           views: ["pageControl": pageControl]))

        return pageControl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareView()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor
        pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor
    }

    fileprivate func prepareView() {

        self.backgroundColor = .clear

        collectionView.delegate = self
        collectionView.dataSource = self
        self.pageControl.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .valueChanged)
        self.layoutIfNeeded()
    }

    open func reloadData() {
        self.setNeedsLayout()
        self.layoutIfNeeded()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.collectionView.reloadData()
        }

        self.pageControl.numberOfPages = self.dataSource?.numberOfItems(in: self) ?? 0
        self.pageControl.currentPage = 0
    }

    @objc
    fileprivate func pageControlTapHandler(sender:UIPageControl) {
        self.reloadData()

        self.collectionView.scrollToItem(at: IndexPath(row: max(self.pageControl.currentPage, 0), section: 0), at: .left, animated: true)
    }

    @objc(registerClass:forItemCellWithReuseIdentifier:)
    open func register(_ cellClass: Swift.AnyClass?, forItemCellWithReuseIdentifier identifier: String) {
        self.collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    @objc(registerNib:forItemCellWithReuseIdentifier:)
    open func register(_ nib: UINib?, forItemCellWithReuseIdentifier identifier: String) {
        self.collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
}

extension UMHorizontalView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.horizontalView?(self, didSelectItemIn: collectionView, at: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.delegate?.horizontalView?(self, didDeselectItemIn: collectionView, at: indexPath)
    }
}

extension UMHorizontalView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = self.dataSource?.numberOfItems(in: self) ?? 0
        return numberOfItems
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.dataSource?.horizontalView(self, cellForItemIn: collectionView, at: indexPath) else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        }
        return cell
    }
}

extension UMHorizontalView: SnappingCollectionViewLayoutDelegate {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, cellCenteredAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.frame.size.width-(self.itemsSpacing * (self.itemsPerPage-1))/self.itemsPerPage
        return CGSize(width: width, height: self.frame.size.height)
    }
}
