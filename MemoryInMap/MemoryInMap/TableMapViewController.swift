//
//  TableMapViewController.swift
//  MapTable-Swift
//
//  Created by Gazolla on 18/07/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit
import MapKit

class TableMapViewController: UIViewController {
    var navHeight:CGFloat?
    var width:CGFloat?
    var mapHeight:CGFloat?
    var tableHeight:CGFloat?
    var height:CGFloat?
    var firstPosition = true
    var tableController:VenuesTableView?
    var venues: Array<Venue> = [Venue]()
    var mapView:MapViewController?
    var tapFirstView:UIGestureRecognizer?
    var bigMap = false
    var detailVenue:VenueDetailViewController?

    convenience init(frame:CGRect ) {
        self.init(nibName: nil, bundle: nil)
//        let frame = UIScreen.mainScreen().bounds
        navHeight = 0.0
        width = frame.size.width
        mapHeight = (frame.size.height - navHeight!)/5*3
        tableHeight = (frame.size.height - navHeight!)/5*2
        height = frame.size.height

        title = "Map & Table"

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableMapViewController.mapViewTapped), name: "mapViewTapped", object: nil)

        mapView = MapViewController(frame: CGRectMake(0.0, navHeight!, width!, mapHeight!))

        tapFirstView = UITapGestureRecognizer(target: self, action: #selector(TableMapViewController.mapViewTapped))
        mapView!.view.addGestureRecognizer(tapFirstView!)
        self.view.addSubview(self.mapView!.view)

        tableController = VenuesTableView(frame: CGRectMake(0.0, mapHeight!, width!, tableHeight!))
        view.addSubview(tableController!.view)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableMapViewController.navigateToDetail(_:)), name: "navigateToDetail", object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.mSetBackgroundColor(UIColor.clearColor())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapViewTapped() {
        if (!bigMap) {
            UIView.animateWithDuration(0.5,
                                       delay: 0,
                                       usingSpringWithDamping: 0.9, //振动幅度,数值越小,弹簧振动效果越明显
                initialSpringVelocity: 20.0, //初始速度,数值越大,开始移动速度越快
                options: UIViewAnimationOptions.CurveEaseIn ,
                animations: {
                    self.mapView!.view.frame = CGRectMake(0.0, self.navHeight!, self.width!, self.height!)
                    self.mapView!.map!.frame = CGRectMake(0.0, self.navHeight!, self.width!, self.height!)
                    self.tableController!.view.center = CGPointMake(self.tableController!.view.center.x, self.tableController!.view.center.y+self.tableHeight!);
                },
                completion:{ (Bool)  in
                    let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TableMapViewController.reverse))
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
                                       options: UIViewAnimationOptions.CurveEaseIn ,
                                       animations: {
                                        self.mapView!.view.frame = CGRectMake(0.0, self.navHeight!, self.width!, self.mapHeight!)
                                        self.mapView!.map!.frame = CGRectMake(0.0, self.navHeight!, self.width!, self.mapHeight!)
                                        self.tableController!.view.center = CGPointMake(self.tableController!.view.center.x, self.tableController!.view.center.y-self.tableHeight!);
                },
                                       completion:{ (Bool)  in
                                        self.navigationItem.leftBarButtonItem = nil
                                        self.bigMap = false

                                        if let selectedAnnotations = self.mapView!.map!.selectedAnnotations as? [MapPointAnnotation]{
                                            for annotation in selectedAnnotations {
                                                self.mapView!.map!.deselectAnnotation(annotation, animated: true)
                                            }
                                        }
            })
        }

    }

    func setVenueCollection(array: [Venue]!) {
        if (array != nil) {
            venues = array!
            tableController!.loadVenues(array!)
            mapView!.loadPointsWithArray(array!)
        }
    }

    func navigateToDetail(notification:NSNotification){
        if self.detailVenue == nil {
            self.detailVenue = VenueDetailViewController()
        }
        if let venue:Venue = notification.object as? Venue {
            self.detailVenue?.lblName?.text = venue.name
            self.detailVenue?.lblAddress?.text = venue.address
            self.detailVenue?.lblCity?.text = venue.city
        } else {
            debugPrint ("no venue at TableMapController")
        }
        self.navigationController?.pushViewController(self.detailVenue!, animated: true)
    }

}
