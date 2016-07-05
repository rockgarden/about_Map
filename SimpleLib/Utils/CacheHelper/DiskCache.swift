//
//  DiskCache.swift
//  Cache
//
//  Created by Sam Soffes on 5/6/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import Foundation

/// Disk cache. All reads run concurrently. Writes wait for all other queue actions to finish and run one at a time
/// using dispatch barriers.
public struct DiskCache<T: NSCoding>: Cache {
    
    // MARK: - Properties
    
    private let directory: String
    private let fileManager = NSFileManager()
    private let queue = dispatch_queue_create("com.samsoffes.cache.disk-cache", DISPATCH_QUEUE_CONCURRENT)
    
    
    // MARK: - Initializers
    
    public init?(directory: String) {
        var isDirectory: ObjCBool = false
        // Ensure the directory exists
        if fileManager.fileExistsAtPath(directory, isDirectory: &isDirectory) && isDirectory {
            self.directory = directory
            return
        }
        
        // Try to create the directory
        do {
            try fileManager.createDirectoryAtPath(directory, withIntermediateDirectories: true, attributes: nil)
            self.directory = directory
        } catch {}
        
        return nil
    }
    
    
    // MARK: - Cache
    
    public func get(key key: String, completion: (T? -> Void)) {
        let path = pathForKey(key)
        
        coordinate {
            let value = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? T
            completion(value)
        }
    }
    
    public func set(key key: String, value: T, completion: (() -> Void)? = nil) {
        let path = pathForKey(key)
        let fileManager = self.fileManager
        
        coordinate(barrier: true) {
            if fileManager.fileExistsAtPath(path) {
                do {
                    try fileManager.removeItemAtPath(path)
                } catch {}
            }
            
            NSKeyedArchiver.archiveRootObject(value, toFile: path)
        }
    }
    
    public func remove(key key: String, completion: (() -> Void)? = nil) {
        let path = pathForKey(key)
        let fileManager = self.fileManager
        
        coordinate {
            if fileManager.fileExistsAtPath(path) {
                do {
                    try fileManager.removeItemAtPath(path)
                } catch {}
            }
        }
    }
    
    /**
     FIXME:对tempDirectory = NSTemporaryDirectory()的文件无效
     
     - parameter completion: <#completion description#>
     */
    public func removeAll(completion completion: (() -> Void)? = nil) {
        let fileManager = self.fileManager
        let directory = self.directory
        
        coordinate {
            guard let paths = try? fileManager.contentsOfDirectoryAtPath(directory) else { return }
            
            for path in paths {
                do {
                    try fileManager.removeItemAtPath(path)
                } catch {}
            }
        }
    }
    
    
    // MARK: - Private
    
    private func coordinate(barrier barrier: Bool = false, block: () -> Void) {
        if barrier {
            dispatch_barrier_async(queue, block)
            return
        }
        
        dispatch_async(queue, block)
    }
    
    private func pathForKey(key: String) -> String {
        return (directory as NSString).stringByAppendingPathComponent(key)
    }
    
    func cleanTemp() {
        var res = Array<NSDate>()
        do {
            if let tmpFiles = try? fileManager.contentsOfDirectoryAtPath(directory)
            {
                for file in tmpFiles {
                    let fullPath = (file as NSString).stringByAppendingPathComponent(file)
                    if fileManager.fileExistsAtPath(fullPath) {
                        do {
                            try fileManager.removeItemAtPath(fullPath)
                        } catch {}
                    }
                    do {
                        
                        if let attr: NSDictionary = try? fileManager.attributesOfItemAtPath(file) {
                            res.append(attr.fileModificationDate()!)
                        }
                    }
                    
                }
            }
        }
        debugPrint(res)
    }
}

extension DiskCache {
    
    //    //清除指定缓存(需加上后缀名，如: 123.mp3)
    //    func cleanCacheFileWithCacheKey(cacheKey:String){
    //        let fullPath = self.cacheFilePath.stringByAppendingPathComponent(cacheKey)
    //        let manager = NSFileManager.defaultManager()
    //        if manager.fileExistsAtPath(fullPath){
    //            manager.removeItemAtPath(fullPath, error: nil)
    //        }
    //    }
    
    //获取tmp文件列表(相对路径，如:[123.mp3,234.mp3])
    //    func cachesList() -> Array<String>? {
    //        do{
    //            if let tmpFiles = try? NSFileManager.defaultManager().contentsOfDirectoryAtPath(temporaryDirectory)
    //            {
    //                return tmpFiles
    //            }
    //        }
    //    }
    
    //    //获取缓存文件完整目录列表
    //    func cacheFileFullPathes() -> Array<String>{
    //        var res = Array<String>()
    //        var arr = self.cachesList()
    //        if arr != nil{
    //            for item in arr!{
    //                res.append(XXYAudioEngine.cacheFilePath.stringByAppendingPathComponent(item))
    //            }
    //        }
    //        return res
    //    }
    
    //    //获取缓存大小(单位：MB)
    //    func cacheSize() -> Float{
    //        var fileList = self.cacheFileFullPathes()
    //        var totalSize = UInt64(0)
    //        for item in fileList{
    //            let attr:NSDictionary = NSFileManager.defaultManager().attributesOfItemAtPath(item, error: nil)!
    //            totalSize += attr.fileSize()
    //        }
    //        return Float(totalSize)/(1024*1024)
    //    }
    
    //    //获取各个缓存文件的下载完成时间
    //    func cacheFinishedDownLoadDates() -> Array<NSDate>{
    //        var fileList = self.cacheFileFullPathes()
    //        var res = Array<NSDate>()
    //        for item in fileList{
    //            do {
    //            let attr:NSDictionary = NSFileManager.defaultManager().attributesOfItemAtPath(item, error: nil)!
    //            }catch {
    //
    //            }
    //            if attr.fileModificationDate() != nil{
    //                res.append(attr.fileModificationDate()!)
    //            }else{
    //                res.append(NSDate())
    //            }
    //        }
    //        return res
    //    }
}
