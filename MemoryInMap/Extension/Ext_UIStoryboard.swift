//
//  Ext_UIStoryboard.swift
//  MemoryInMap
//
//  Created by wangkan on 16/7/26.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import UIKit

extension UIStoryboard {

	enum Storyboard: String {
		case Main
	}

	convenience init(storyboard: Storyboard, bundle: NSBundle? = nil) {
		self.init(name: storyboard.rawValue, bundle: bundle)
	}

	convenience init(storyboardName: String, bundle: NSBundle? = nil) {
		self.init(name: storyboardName, bundle: bundle)
	}

	class func storyboard(storyboard: Storyboard, bundle: NSBundle? = nil) -> UIStoryboard {
		return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
	}

	func instantiateViewController<T: UIViewController where T: StoryboardIdentifiable>() -> T {
		guard let viewController = instantiateViewControllerWithIdentifier(T.storyboardIdentifier) as? T else {
			fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
		}
		return viewController
	}

	func getViewControllerFromStoryboard(viewController: String, storyboard: String) -> UIViewController {
		let sBoard = UIStoryboard(name: storyboard, bundle: nil)
		let vController: UIViewController = sBoard.instantiateViewControllerWithIdentifier(viewController)
		return vController
	}
}

extension UIViewController: StoryboardIdentifiable { }

/**
 *  identifiable
 */
protocol StoryboardIdentifiable {
	static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
	static var storyboardIdentifier: String {
		return String(self)
	}
}

