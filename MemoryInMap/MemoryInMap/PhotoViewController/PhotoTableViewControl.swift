//
//  PhotoTableViewControl.swift
//  MemoryInMap
//
//  Created by wangkan on 16/7/26.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import UIKit
import SimpleLib

class PhotoTableViewController: ExpandingTableViewController {
    
    private var scrollOffsetY: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        let image1 = UIImage.Asset.BackgroundImage.image
        tableView.backgroundView = UIImageView(image: image1)
    }
}
// MARK: Helpers

extension PhotoTableViewController {
    
    private func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        navigationItem.rightBarButtonItem?.image = navigationItem.rightBarButtonItem?.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    }
}

// MARK: Actions

extension PhotoTableViewController {
    
    @IBAction func backButtonHandler(sender: AnyObject) {
        // buttonAnimation
        let viewControllers: [PhotoViewController?] = navigationController?.viewControllers.map { $0 as? PhotoViewController } ?? []
        
        for viewController in viewControllers {
            if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(false)
            }
        }
        popTransitionAnimation()
    }
}

// MARK: UIScrollViewDelegate

extension PhotoTableViewController {
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        //    if scrollView.contentOffset.y < -25 {
        //      // buttonAnimation
        //      let viewControllers: [DemoViewController?] = navigationController?.viewControllers.map { $0 as? DemoViewController } ?? []
        //
        //      for viewController in viewControllers {
        //        if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
        //          rightButton.animationSelected(false)
        //        }
        //      }
        //      popTransitionAnimation()
        //    }
        
        scrollOffsetY = scrollView.contentOffset.y
    }
}
