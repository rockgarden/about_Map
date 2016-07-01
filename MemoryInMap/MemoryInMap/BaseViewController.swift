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
		if showStatusBar {
			return false
		}
		return true
	}

//	override public func preferredStatusBarStyle() -> UIStatusBarStyle {
//		return UIStatusBarStyle.LightContent
//	}

    /**
     StatusBar的显示与隐藏只有在加载时才有效
     一般在地图与图片浏览等对显示区域有最大化需求的场景
     
     - parameter bool: false隐藏/true显示
     */
	func showStatusBar(bool: Bool) {
		showStatusBar = bool
		prefersStatusBarHidden()
	}

}