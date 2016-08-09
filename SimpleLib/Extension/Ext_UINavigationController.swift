//
//  ExtKIT
//  Ext_UINavigationController.swift
//  MemoryInMap
//
//  Created by wangkan on 16/6/6.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import UIKit

@IBDesignable
extension UINavigationController {
    
    /**
     获取NavBar+StatusBar的高度
     
     - returns: 当前VC的Bar的高度
     */
    func getBarHeight() -> CGFloat {
        let heightNavBar = self.navigationBar.frame.height ?? 0
        let heightStatusBar = UIApplication.sharedApplication().statusBarFrame.height ?? 0
        return heightNavBar + heightStatusBar
    }

}