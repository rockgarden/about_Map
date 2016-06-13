//
//  TableMapViewController.swift
//
//  Created by Wangkan on 01/06/16.
//  Copyright (c) 2016 Rockgarden. All rights reserved.
//

import UIKit
import MapKit

class TableMapViewController: UIViewController, NavigationBarColorSource {
    
    var navHeight: CGFloat?
    var width: CGFloat?
    var mapHeight: CGFloat?
    var tableHeight: CGFloat?
    var height: CGFloat?
    var firstPosition = true
    var tableController: PhotosTableView?
    var photos: Array<Photo> = [Photo]()
    var mapView: MapViewController?
    var tapFirstView: UIGestureRecognizer?
    var bigMap = false
    var detailPhoto: PhotoDetailViewController?
    
    // FIXME:用init方法时无法重置navigationBar的背景
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        initView()
    }
    
    func initView() {
        let frame = UIScreen.mainScreen().bounds
        navHeight = 0.0
        width = frame.size.width
        mapHeight = (frame.size.height - navHeight!) / 4 * 3
        tableHeight = (frame.size.height - navHeight!) / 4 * 1
        height = frame.size.height
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableMapViewController.mapViewTapped), name: "mapViewTapped", object: nil)
        
        mapView = MapViewController(frame: CGRectMake(0.0, navHeight!, width!, mapHeight!))
        
        tapFirstView = UITapGestureRecognizer(target: self, action: #selector(TableMapViewController.mapViewTapped))
        mapView!.view.addGestureRecognizer(tapFirstView!)
        self.view.addSubview(self.mapView!.view)
        
        tableController = PhotosTableView(frame: CGRectMake(0.0, mapHeight!, width!, tableHeight!))
        view.addSubview(tableController!.view)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableMapViewController.navigateToDetail(_:)), name: "navigateToDetail", object: nil)
        
        let rightBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(TableMapViewController.reverse))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactiveNavigationBarHidden = false
        title = "Map & Table"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.interactiveNavigationBarHidden = true
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        setPhotosCollection()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapViewTapped() {
        if (!bigMap) {
            UIView.animateWithDuration(0.5,
                                       delay: 0,
                                       usingSpringWithDamping: 0.9, // 振动幅度,数值越小,弹簧振动效果越明显
                initialSpringVelocity: 20.0, // 初始速度,数值越大,开始移动速度越快
                options: UIViewAnimationOptions.CurveEaseIn,
                animations: {
                    self.mapView!.view.frame = CGRectMake(0.0, self.navHeight!, self.width!, self.height!)
                    self.mapView!.map!.frame = CGRectMake(0.0, self.navHeight!, self.width!, self.height!)
                    self.tableController!.view.center = CGPointMake(self.tableController!.view.center.x, self.tableController!.view.center.y + self.tableHeight!);
                },
                completion: { (Bool) in
                    let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TableMapViewController.reverse))
                    self.navigationItem.leftBarButtonItem = leftBarButtonItem
                    self.bigMap = true
            })
        } else {
            reverse()
        }
    }
    
    func reverse() {
        if bigMap {
            UIView.animateWithDuration(0.5,
                                       delay: 0,
                                       usingSpringWithDamping: 0.9,
                                       initialSpringVelocity: 20.0,
                                       options: UIViewAnimationOptions.CurveEaseIn,
                                       animations: {
                                        self.mapView!.view.frame = CGRectMake(0.0, self.navHeight!, self.width!, self.mapHeight!)
                                        self.mapView!.map!.frame = CGRectMake(0.0, self.navHeight!, self.width!, self.mapHeight!)
                                        self.tableController!.view.center = CGPointMake(self.tableController!.view.center.x, self.tableController!.view.center.y - self.tableHeight!);
                },
                                       completion: { (Bool) in
                                        self.navigationItem.leftBarButtonItem = nil
                                        self.bigMap = false
                                        
                                        if let selectedAnnotations = self.mapView!.map!.selectedAnnotations as? [MapPointAnnotation] {
                                            for annotation in selectedAnnotations {
                                                self.mapView!.map!.deselectAnnotation(annotation, animated: true)
                                            }
                                        }
            })
        }
        
    }
    
    func setPhotosCollection() {
        tableController!.loadPhotos(photos)
        mapView!.loadPointsWithArray(photos)
    }
    
    func navigateToDetail(notification: NSNotification) {
        if self.detailPhoto == nil {
            self.detailPhoto = PhotoDetailViewController()
        }
        if let photo = notification.object as? Photo {
            self.detailPhoto?.lblName?.text = photo.name
            self.detailPhoto?.lblAddress?.text = photo.address
            self.detailPhoto?.lblCity?.text = photo.city
        } else {
            debugPrint ("no venue at TableMapController")
        }
        self.navigationController?.pushViewController(self.detailPhoto!, animated: true)
    }
    
    /**
     返回本VC时的BackgroundColor
     - returns: navigationBar color
     */
    func navigationBarInColor() -> UIColor {
        return UIColor.redColor()
    }
    
}
