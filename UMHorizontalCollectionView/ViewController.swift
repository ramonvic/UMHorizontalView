//
//  ViewController.swift
//  UMHorizontalCollectionView
//
//  Created by Ramon Vicente on 18/08/17.
//  Copyright © 2017 Umobi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var horizontalScroll: UMHorizontalView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        horizontalScroll.dataSource = self
        horizontalScroll.register(UINib(nibName: "TestimonialCollectionViewCell", bundle: nil), forItemCellWithReuseIdentifier: "TestimonialCollectionViewCell")
        horizontalScroll.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UMHorizontalViewDataSource {
    func numberOfItems(in horizontalView: UMHorizontalView) -> Int {
        return 20
    }

    func horizontalView(_ horizontalView: UMHorizontalView, cellForItemIn collectionView: UICollectionView, at indexPath: IndexPath) -> UMHorizontalViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestimonialCollectionViewCell", for: indexPath) as! TestimonialCollectionViewCell
        cell.backgroundColor = .clear
        return cell
    }
}
