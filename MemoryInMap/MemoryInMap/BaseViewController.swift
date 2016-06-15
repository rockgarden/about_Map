//
//  BaseUIViewController.swift
//  MemoryInMap
//
//  Created by wangkan on 16/6/15.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import UIKit

public class BaseViewController: UIViewController {
    
    var showStatusBar = true

    // MARK:- init
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override public func prefersStatusBarHidden() -> Bool {
        if self.showStatusBar {
            return false
        }
        return true
    }
    
    private func showStatusBar(bool: Bool) {
        showStatusBar = bool
        prefersStatusBarHidden()
    }
    
}