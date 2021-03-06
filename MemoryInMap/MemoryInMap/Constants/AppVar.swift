//
//  PublicVar.swift
//  MemoryInMap
//
//  Created by wangkan on 16/7/26.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import UIKit
import SimpleLib

public var appID = getDictionaryFromInfoPlist("appID") as! String
public var appName = getDictionaryFromInfoPlist("appName") as! String
public let modelName = UIDevice.currentDevice().modelName
public let tempDirectory = NSTemporaryDirectory()
public let FileManager = NSFileManager.defaultManager()
let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate