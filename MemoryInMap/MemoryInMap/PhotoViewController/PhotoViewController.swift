//
//  DemoViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 12/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import SimpleLib

class PhotoViewController: ExpandingViewController {

	typealias ItemInfo = (imageName: String, title: String)
	private var cellsIsOpen = [Bool]()
	private let items: [ItemInfo] = [("item0", "Boston"), ("item1", "New York"), ("item2", "San Francisco"), ("item3", "Washington")]

	@IBOutlet weak var pageLabel: UILabel!
}

// MARK: - life cicle
extension PhotoViewController {

	override func viewDidLoad() {
        let barHeight = self.navigationController?.getBarHeight()
        // 重定义Collection cell大小
		itemSize = CGSize(width: SCREEN_WIDTH - 40, height: SCREEN_HEIGHT - barHeight! * 2 )
		super.viewDidLoad()
		registerCell()
		fillCellIsOpeenArry()
		addGestureToView(collectionView!)
		configureNavBar()
	}
}

// MARK: - Helpers

extension PhotoViewController {
	/**
	 用类名动态注册ReuseIdentifier
	 */
	private func registerCell() {
		let nib = UINib(nibName: String(PhotoCollectionViewCell), bundle: nil)
		collectionView?.registerNib(nib, forCellWithReuseIdentifier: String(PhotoCollectionViewCell))
	}

	private func fillCellIsOpeenArry() {
		for _ in items {
			cellsIsOpen.append(false)
		}
	}

	private func getViewController() -> ExpandingTableViewController {
		let storyboard = UIStoryboard(storyboardName: "PhotoExpandingCollection")
		let toViewController: PhotoTableViewController = storyboard.instantiateViewController()
		return toViewController
	}

	private func configureNavBar() {
		navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
	}
}

// MARK: - Gesture

extension PhotoViewController {

	private func addGestureToView(toView: UIView) {
		let gesutereUp = Init(UISwipeGestureRecognizer(target: self, action: #selector(PhotoViewController.swipeHandler(_:)))) {
			$0.direction = .Up
		}
		let gesutereDown = Init(UISwipeGestureRecognizer(target: self, action: #selector(PhotoViewController.swipeHandler(_:)))) {
			$0.direction = .Down
		}
		toView.addGestureRecognizer(gesutereUp)
		toView.addGestureRecognizer(gesutereDown)
	}

	func swipeHandler(sender: UISwipeGestureRecognizer) {
		let indexPath = NSIndexPath(forRow: currentIndex, inSection: 0)
		guard let cell = collectionView?.cellForItemAtIndexPath(indexPath) as? PhotoCollectionViewCell else { return }
		// TODO: double swipe Up transition
		if cell.isOpened == true && sender.direction == .Up {
			pushToViewController(getViewController())
			if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
				rightButton.animationSelected(true)
			}
		}
		let open = sender.direction == .Up ? true : false
		cell.cellIsOpen(open)
		cellsIsOpen[indexPath.row] = cell.isOpened
        pageLabel.hidden = cell.isOpened
	}
}

// MARK: - UIScrollViewDelegate

extension PhotoViewController {

	func scrollViewDidScroll(scrollView: UIScrollView) {
		pageLabel.text = "\(currentIndex+1)/\(items.count)"
	}
}

// MARK: - UICollectionViewDataSource

extension PhotoViewController {

	override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		super.collectionView(collectionView, willDisplayCell: cell, forItemAtIndexPath: indexPath)
		guard let cell = cell as? PhotoCollectionViewCell else { return }

		let index = indexPath.row % items.count
		let info = items[index]
		cell.backgroundImageView?.image = UIImage(named: info.imageName)
		cell.customTitle.text = info.title
		cell.cellIsOpen(cellsIsOpen[index], animated: false)
        pageLabel.hidden = cellsIsOpen[index]
	}

	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PhotoCollectionViewCell
		where currentIndex == indexPath.row else { return }

		if cell.isOpened == false {
			cell.cellIsOpen(true)
		} else {
			pushToViewController(getViewController())
			if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
				rightButton.animationSelected(true)
			}
		}
	}
}

// MARK: - UICollectionViewDataSource

extension PhotoViewController {

	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}

	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		return collectionView.dequeueReusableCellWithReuseIdentifier(String(PhotoCollectionViewCell), forIndexPath: indexPath)
	}
}
