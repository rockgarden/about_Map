//
//  GeotificationsViewController.swift
//  Geotify
//
//  Created by Ken Toh on 24/1/15.
//  Copyright (c) 2015 Ken Toh. All rights reserved.
//

import UIKit
import MapKit
import SimpleLib

let kSavedItemsKey = "savedItems"

class GeotificationsViewController: UIViewController, AddGeotificationsViewControllerDelegate,
MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var geotifications = [Geotification]()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        //Asking for authorization to display current location
        if status == CLAuthorizationStatus.NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
        loadAllGeotifications()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addGeotification" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let vc = navigationController.viewControllers.first as! AddGeotificationViewController
            vc.delegate = self
        }
    }
    
    // MARK: Loading and saving functions
    
    func loadAllGeotifications() {
        geotifications = []
        
        if let savedItems = NSUserDefaults.standardUserDefaults().arrayForKey(kSavedItemsKey) {
            for savedItem in savedItems {
                if let geotification = NSKeyedUnarchiver.unarchiveObjectWithData(savedItem as! NSData) as? Geotification {
                    addGeotification(geotification)
                }
            }
        }
    }
    
    func saveAllGeotifications() {
        let items = NSMutableArray()
        for geotification in geotifications {
            let item = NSKeyedArchiver.archivedDataWithRootObject(geotification)
            items.addObject(item)
        }
        NSUserDefaults.standardUserDefaults().setObject(items, forKey: kSavedItemsKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    // MARK: Functions that update the model/associated views with geotification changes
    
    func addGeotification(geotification: Geotification) {
        geotifications.append(geotification)
        mapView.addAnnotation(geotification)
        addRadiusOverlayForGeotification(geotification)
        updateGeotificationsCount()
    }
    
    func removeGeotification(geotification: Geotification) {
        if let indexInArray = geotifications.indexOf(geotification) {
            geotifications.removeAtIndex(indexInArray)
        }
        
        mapView.removeAnnotation(geotification)
        removeRadiusOverlayForGeotification(geotification)
        updateGeotificationsCount()
    }
    
    func updateGeotificationsCount() {
        title = "Geotifications (\(geotifications.count))"
    }
    
    // MARK: AddGeotificationViewControllerDelegate
    
    func addGeotificationViewController(controller: AddGeotificationViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String, eventType: EventType) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        // Add geotification
        let geotification = Geotification(coordinate: coordinate, radius: radius, identifier: identifier, note: note, eventType: eventType)
        addGeotification(geotification)
        saveAllGeotifications()
    }
    
    // MARK: MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "myGeotification"
        if annotation is Geotification {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                let removeButton = UIButton(type: .Custom) 
                removeButton.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
                removeButton.setImage(UIImage(named: "DeleteGeotification")!, forState: .Normal)
                annotationView?.leftCalloutAccessoryView = removeButton
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        //    if overlay is MKCircle {
        //
        //    }
        //    return MKCircleRenderer(overlay: overlay)
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.lineWidth = 1.0
        circleRenderer.strokeColor = UIColor.purpleColor()
        circleRenderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.4)
        return circleRenderer
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Delete geotification
        let geotification = view.annotation as! Geotification
        removeGeotification(geotification)
        saveAllGeotifications()
    }
    
    // MARK: Map overlay functions
    
    func addRadiusOverlayForGeotification(geotification: Geotification) {
        mapView?.addOverlay(MKCircle(centerCoordinate: geotification.coordinate, radius: geotification.radius))
    }
    
    func removeRadiusOverlayForGeotification(geotification: Geotification) {
        // Find exactly one overlay which has the same coordinates & radius to remove
        if let overlays = mapView?.overlays {
            for overlay in overlays {
                if let circleOverlay = overlay as? MKCircle {
                    let coord = circleOverlay.coordinate
                    if coord.latitude == geotification.coordinate.latitude && coord.longitude == geotification.coordinate.longitude && circleOverlay.radius == geotification.radius {
                        mapView?.removeOverlay(circleOverlay)
                        break
                    }
                }
            }
        }
    }
    
    // MARK: Other mapview functions
    
    @IBAction func zoomToCurrentLocation(sender: AnyObject) {
        zoomToUserLocationInMapView(mapView)
    }

    // The location manager calls locationManager(_:didChangeAuthorizationStatus:) whenever the authorization status changes. If the user has already granted the app permission to use Location Services, this method will be called by the location manager after you’ve initialized the location manager and set its delegate.
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .AuthorizedWhenInUse)
    }

    func regionWithGeotification(geotification: Geotification) -> CLCircularRegion {
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        region.notifyOnEntry = (geotification.eventType == .OnEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
}
