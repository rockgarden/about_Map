//
//  VenuesTableView.swift
//  MapTable-Swift
//
//  Created by Gazolla on 18/07/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit
import SimpleLib

class PhotosTableView: UITableViewController {
    
    var photos: [Photo] = []
    var rightButton:UIButton?
    let cellId = "cell"

    let kCloseCellHeight: CGFloat = 20
    let kOpenCellHeight: CGFloat = 488
    var cellHeights = [CGFloat]()
     
    convenience init(frame:CGRect){
        self.init(style:.Plain)
        self.title = "Plain Table"
        self.view.frame = frame
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellId)
    }
    
    func loadPhotos(array: [Photo]) {
        self.photos = array
        createCellHeightsArray()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }

    // MARK: configure
    func createCellHeightsArray() {
        for _ in 0..<photos.count {
            cellHeights.append(kCloseCellHeight)
        }
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.photos.count as Int
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell is FoldingCell {
            let foldingCell = cell as! FoldingCell
            foldingCell.backgroundColor = UIColor.clearColor()

            if cellHeights[indexPath.row] == kCloseCellHeight {
                foldingCell.selectedAnimation(false, animated: false, completion:nil)
            } else {
                foldingCell.selectedAnimation(true, animated: false, completion: nil)
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellId, forIndexPath: indexPath)
        // TODO:使用FoldingCell
//        let cell = tableView.dequeueReusableCellWithIdentifier("FoldingCell", forIndexPath: indexPath)
        let photo = self.photos[indexPath.row] as Photo
        cell.textLabel!.text = photo.name
        debugPrint ("venue category: \(photo.categoryName)")
//        cell.detailTextLabel!.text = photo.categoryName
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }

    // MARK: Table vie delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        debugPrint (indexPath.row)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell?
        debugPrint (cell?.textLabel?.text)
        NSNotificationCenter.defaultCenter().postNotificationName("mapViewTapped", object: nil)
        let venue = self.photos[indexPath.row] as Photo
        NSNotificationCenter.defaultCenter().postNotificationName("selectAnnotation", object: venue)
    }

//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FoldingCell
//
//        if cell.isAnimating() {
//            return
//        }
//
//        var duration = 0.0
//        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
//            cellHeights[indexPath.row] = kOpenCellHeight
//            cell.selectedAnimation(true, animated: true, completion: nil)
//            duration = 0.5
//        } else {// close cell
//            cellHeights[indexPath.row] = kCloseCellHeight
//            cell.selectedAnimation(false, animated: true, completion: nil)
//            duration = 0.8
//        }
//
//        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
//            tableView.beginUpdates()
//            tableView.endUpdates()
//            }, completion: nil)
//    }

}
