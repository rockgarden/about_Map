//
//  PublicFunc.swift
//  MemoryInMap
//
//  Created by wangkan on 16/7/28.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import UIKit

//TODO: 实现传入self
func getBarHeight(viewController: AnyObject) -> CGFloat {
	//let heightNavBar = self.navigationController!.navigationBar.frame.height ?? 0
	let heightStatusBar = UIApplication.sharedApplication().statusBarFrame.height ?? 0
	//return heightNavBar + heightStatusBar
    return heightStatusBar
}