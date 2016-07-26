//
//  PublicVar.swift
//  MemoryInMap
//
//  Created by wangkan on 16/7/26.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import UIKit

public var appID = getDictionaryFromInfoPlist("appID") as! String
public var appName = getDictionaryFromInfoPlist("appName") as! String
public var appVersion = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String!
public let modelName = UIDevice.currentDevice().modelName
public let SCREEN_WIDTH = UIScreen.mainScreen().bounds.width
public let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height
public let tempDirectory = NSTemporaryDirectory()
public let FileManager = NSFileManager.defaultManager()