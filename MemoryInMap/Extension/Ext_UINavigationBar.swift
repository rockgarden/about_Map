//
//  ExtKIT
//  Ext_NavBar.swift
//
//
//  Created by wangkan on 16/5/26.
//  Copyright © 2016年 wangkan. All rights reserved.
//

import Foundation
import UIKit

private var kBackgroundViewKey = "kBackgroundViewKey"
private var kStatusBarMaskKey = "kStatusBarMaskKey"

extension UINavigationBar {
    
    // MARK: - Instance functions -
    
    /**
     Set the UINavigationBar to transparent or not
     在AppDelegate中要通过appearance()调用:UINavigationBar.appearance().setTransparent(true)
     相当于
     // transparent background
     UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
     UINavigationBar.appearance().shadowImage = UIImage()
     UINavigationBar.appearance().translucent = true
     
     - parameter transparent: true to set it transparent, false to not
     - parameter translucent: A Boolean value indicating whether the navigation bar is translucent or not
     */
    public func setTransparent(transparent: Bool, translucent: Bool = true) {
        if transparent {
            self.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            self.shadowImage = UIImage()
            self.translucent = translucent
        } else {
            self.setBackgroundImage(nil, forBarMetrics: .Default)
            self.shadowImage = nil
            self.translucent = translucent
        }
    }
    
    /**
     @deprecated
     StatusBar Background Color 同 NavigationBar
     如:当NavigationBar设置透明图片时, StatusBar也为透明.
     注意: NavigationBar所在的VC的背景一定要延伸到StatusBar,这样才能保证效果一致.
     对于普通的UIView需要加上Top.constant = - 64, ScrollView默认充满UIScreen.
     - parameter color: UIColor
     */
    @objc
    public func mSetStatusBarMaskColor(color: UIColor) {
        if statusBarMask == nil {
            statusBarMask = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.mainScreen().bounds.width, height: 20))
            statusBarMask?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            if let tempBackgroundView = backgroundView {
                insertSubview(statusBarMask!, aboveSubview: tempBackgroundView)
            } else {
                insertSubview(statusBarMask!, atIndex: 0)
            }
        }
        statusBarMask?.backgroundColor = color
    }
    
    /**
     @deprecated
     设定NavigationBar BackgroundImage
     
     - parameter color: UIColor
     */
    @objc
    public func mSetBackgroundColor(color: UIColor) {
        if backgroundView == nil {
            setBackgroundImage(UIImage(), forBarMetrics: .Default)
            shadowImage = UIImage()
            backgroundView = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.mainScreen().bounds.width, height: 64))
            backgroundView?.userInteractionEnabled = false
            backgroundView?.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            insertSubview(backgroundView!, atIndex: 0)
        }
        backgroundView?.backgroundColor = color
    }
    
    public func resetBackgroundColor() {
        setBackgroundImage(nil, forBarMetrics: .Default)
        shadowImage = nil
        backgroundView?.removeFromSuperview()
        backgroundView = nil
    }
    
    // MARK: - MethodSwizzling var -
    private var backgroundView: UIView? {
        get {
            return objc_getAssociatedObject(self, &kBackgroundViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &kBackgroundViewKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private var statusBarMask: UIView? {
        get {
            return objc_getAssociatedObject(self, &kStatusBarMaskKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &kStatusBarMaskKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
}