//
//  Ext_UIViewController.swift
//  基于运行时中关联对象(associated objects)和方法交叉(method swizzling)实现
//
//  Created by wangkan on 16/6/5.
//  Copyright © 2016年 wangkan. All rights reserved.
//

import UIKit

private var didKDVCInitialized = false
private var interactiveNavigationBarHiddenAssociationKey: UInt8 = 0

@IBDesignable
extension UIViewController {

	@IBInspectable
    public var interactiveNavigationBarHidden: Bool {
		get {
			let associateValue = objc_getAssociatedObject(self, &interactiveNavigationBarHiddenAssociationKey) ?? false
			return associateValue as! Bool
		}
		set {
			objc_setAssociatedObject(self, &interactiveNavigationBarHiddenAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}



	override public static func initialize() {
		if !didKDVCInitialized {
            SwizzleMethod(self, #selector(UIViewController.viewWillAppear(_:)), #selector(UIViewController.KD_interactiveViewWillAppear(_:)))
			didKDVCInitialized = true
		}
	}

    static func SwizzleMethod(cls: AnyClass, _ originalSelector: Selector, _ swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(cls, originalSelector)
        let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
        let didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        if didAddMethod {
            class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }

	private static func replaceInteractiveMethods() {
		method_exchangeImplementations(
			class_getInstanceMethod(self, #selector(UIViewController.viewWillAppear(_:))),
			class_getInstanceMethod(self, #selector(UIViewController.KD_interactiveViewWillAppear(_:))))
	}

	func KD_interactiveViewWillAppear(animated: Bool) {
		KD_interactiveViewWillAppear(animated)
		navigationController?.setNavigationBarHidden(interactiveNavigationBarHidden, animated: animated)
	}

    func km_containerViewBackgroundColor() -> UIColor {
        return UIColor.whiteColor()
    }

}