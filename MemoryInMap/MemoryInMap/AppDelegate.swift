//
//  AppDelegate.swift
//  MemoryInMap
//
//  Created by wangkan on 16/4/14.
//  Copyright © 2016年 wangkan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var photosArr: Array<Photo> = []

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		initData()
		self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
		let vtv: TableMapViewController = TableMapViewController()
		vtv.photos = photosArr
		self.window!.rootViewController = UINavigationController(rootViewController: vtv)
		self.window!.makeKeyAndVisible()
		return true
	}

	// Override point for customization after application launch.
	func initData() {
		let v = Photo(aIdent: 1, aName: "Whole Foods Market", aAddress: "20955 Stevens Creek Blvd", aCity: "Cupertino", aCategoryName: "Grocery Store", aLat: "37.323551", aLng: "-122.039653")
		let v2 = Photo(aIdent: 2, aName: "Buffalo Wild Wings Grill & Bar", aAddress: "1620 Saratoga Ave", aCity: "San Jose", aCategoryName: "American Restaurant", aLat: "37.2979039", aLng: "-121.988112")
		let v3 = Photo(aIdent: 3, aName: "Bierhaus", aAddress: "383 Castro St", aCity: "Mountain View", aCategoryName: "Gastropub", aLat: "37.3524382", aLng: "-121.9582429")
		let v4 = Photo(aIdent: 4, aName: "Singularity University", aAddress: "Building 20 S. Akron Rd.", aCity: "Moffett Field", aCategoryName: "University", aLat: "37.3996033", aLng: "-122.0784488")
		let v5 = Photo(aIdent: 5, aName: "Menlo Country Club", aAddress: "", aCity: "Woodside", aCategoryName: "Country Club", aLat: "37.4823348", aLng: "-122.2406688")
		let v6 = Photo(aIdent: 6, aName: "Denny's", aAddress: "1015 Blossom Hill Rd", aCity: "San Jose", aCategoryName: "American Restaurant", aLat: "37.2384776", aLng: "-121.8007709")
		let v7 = Photo(aIdent: 7, aName: "Refuge", aAddress: "963 Laurel St", aCity: "San Carlos", aCategoryName: "Restaurant", aLat: "37.5041949", aLng: "-122.2695079")
		photosArr = [v, v2, v3, v4, v5, v6, v7]
	}

	// App样式设定
	func customStyle() {
		self.window!.backgroundColor = UIColor.clearColor()
		UINavigationBar.appearance().barTintColor = UIColor(red: 0.0, green: 0.549, blue: 0.89, alpha: 1.0)
		UINavigationBar.appearance().tintColor = .whiteColor()
		UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
		self.window?.rootViewController?.navigationController?.navigationBar.mSetBackgroundColor(UIColor.redColor())
		// (.LightContent, animated: false)
	}

    func requestsUserPermission() {
        ICanHas.Location { (authorized, status, denied) -> Void in
        }
    }

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

}

