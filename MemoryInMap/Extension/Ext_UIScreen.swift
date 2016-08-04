//
//  Ext_UIScreen.swift
//  MemoryInMap
//
//  Created by wangkan on 16/7/28.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Global variables -

/// Get the screen width
public var SCREEN_WIDTH: CGFloat {
	get {
		return UIScreen.mainScreen().fixedScreenSize().width
        //UIScreen.mainScreen().bounds.width
	}
}

/// Get the screen height
public var SCREEN_HEIGHT: CGFloat {
	get {
		return UIScreen.mainScreen().fixedScreenSize().height
        //UIScreen.mainScreen().bounds.height
	}
}

/// Get the maximum screen length
public var SCREEN_MAX_LENGTH: CGFloat {
	get {
		return max(SCREEN_WIDTH, SCREEN_HEIGHT)
	}
}
/// Get the minimum screen length
public var SCREEN_MIN_LENGTH: CGFloat {
	get {
		return min(SCREEN_WIDTH, SCREEN_HEIGHT)
	}
}

/**
 *  A structure of Bool to check the screen size
 */
public struct SCREENSIZE {
	public static let IS_IPHONE_4_OR_LESS = UIDevice.currentDevice().userInterfaceIdiom == .Phone && SCREEN_MAX_LENGTH < 568.0
	public static let IS_IPHONE_5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && SCREEN_MAX_LENGTH == 568.0
	public static let IS_IPHONE_6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && SCREEN_MAX_LENGTH == 667.0
	public static let IS_IPHONE_6P = UIDevice.currentDevice().userInterfaceIdiom == .Phone && SCREEN_MAX_LENGTH == 736.0
	public static let IS_IPAD = UIDevice.currentDevice().userInterfaceIdiom == .Pad && SCREEN_MAX_LENGTH == 1024.0
}

/// This extesion adds some useful functions to UIScreen
public extension UIScreen {
	// MARK: - Class functions -

	/**
	 Check if the current device has a Retina display

	 - returns: Returns true if it has a Retina display, false if not
	 */
	public static func isRetina() -> Bool {
		if UIScreen.mainScreen().respondsToSelector(#selector(UIScreen.displayLinkWithTarget(_: selector:))) && (UIScreen.mainScreen().scale == 2.0 || UIScreen.mainScreen().scale == 3.0) {
			return true
		} else {
			return false
		}
	}

	/**
	 Check if the current device has a Retina HD display

	 - returns: Returns true if it has a Retina HD display, false if not
	 */
	public static func isRetinaHD() -> Bool {
		if UIScreen.mainScreen().respondsToSelector(#selector(UIScreen.displayLinkWithTarget(_: selector:))) && UIScreen.mainScreen().scale == 3.0 {
			return true
		} else {
			return false
		}
	}

	// MARK: - Instance functions -

	/**
	 Returns the fixed screen size, based on device orientation

	 - returns: Returns a GCSize with the fixed screen size
	 */
	public func fixedScreenSize() -> CGSize {
		let screenSize = self.bounds.size

		if NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1 && UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
			return CGSizeMake(screenSize.height, screenSize.width)
		}

		return screenSize
	}

	/// 0.0 to 1.0, where 1.0 is maximum brightness
	public static var brightness: Float {
		get {
			return Float(UIScreen.brightness)
		}
		set(newValue) {
			UIScreen.brightness = newValue
		}
	}
}

