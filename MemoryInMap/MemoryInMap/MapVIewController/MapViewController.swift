//
//  MapViewController.swift
//  Map-swift
//
//  Created by Gazolla on 25/07/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

	/// Main variables
	var photoPoints: [Int: MapPointAnnotation] = [Int: MapPointAnnotation]()
	var mapView: MKMapView? // 定义MKMapView
	let locationManager = CLLocationManager() // 创建CLLocationManager对象
	var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
	var photos: [Photo]?
	var rightButton: UIButton?
	var selectedVenue: Photo? {
		didSet {
		}
	}

	convenience init(frame: CGRect) {
		self.init(nibName: nil, bundle: nil)
		self.view.frame = frame

		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.selectAnnotation(_:)), name: "selectAnnotation", object: nil)

		self.mapView = MKMapView(frame: frame)
		self.mapView!.delegate = self
		self.view.addSubview(self.mapView!)

		self.mapView!.showsUserLocation = true // 调用setShowUserLocation来获得当前位置
		self.mapView!.hidden = false // 是否隐藏MKMapView

		locationManager.delegate = self // 设置CLLocationManagerDelegate委托对象
		locationManager.distanceFilter = kCLDistanceFilterNone // CLLocationManager对象返回全部结果
		locationManager.desiredAccuracy = kCLLocationAccuracyBest // CLLocationManager对象的返回结果尽可能的精准
		showUserLocation(self)

		adjustRegion(37.3175, aLongitude: -122.0419)
	}

	/// Showing the user location
	func showUserLocation(sender: AnyObject) {
		let status = CLLocationManager.authorizationStatus()
		// Asking for authorization to display current location
		if status == CLAuthorizationStatus.NotDetermined {
			locationManager.requestWhenInUseAuthorization()
		} else {
			locationManager.startUpdatingLocation() // CLLocationManager对象开始定位
		}
	}

	// User authorized to show his current location
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		// zoomToUserLocationInMapView(map!)
		// zoomToUserLocationInMapView(manager, mapView: map!)
	}

	// User changed the authorization to use location, The location manager calls locationManager(_:didChangeAuthorizationStatus:) whenever the authorization status changes. If the user has already granted the app permission to use Location Services, this method will be called by the location manager after you’ve initialized the location manager and set its delegate.
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		// Request user authorization
		locationManager.requestWhenInUseAuthorization()
		mapView!.showsUserLocation = (status == .AuthorizedWhenInUse)
	}

	// Error locating the user
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		print("Error locating the user: \(error)")
	}

	// Drop pin using curret user location
	func dropPhotoPinInCurrentLocation(sender: AnyObject) {
		// Creating new annotation (pin)
		let currentAnnotation: MKPointAnnotation = MKPointAnnotation()
		// Annotation coordinates
		currentAnnotation.coordinate = currentLocation
		// Annotation title
		currentAnnotation.title = "Your Are Here!"
		// Adding the annotation to the map
		mapView!.addAnnotation(currentAnnotation)
		// Displaying the pin title on drop
		mapView!.selectAnnotation(currentAnnotation, animated: true)
	}

	func adjustRegion(aLatitude: CLLocationDegrees, aLongitude: CLLocationDegrees) {
		let latitude: CLLocationDegrees = aLatitude
		let longitude: CLLocationDegrees = aLongitude
		let latDelta: CLLocationDegrees = 1.0
		let longDelta: CLLocationDegrees = 1.0
		let aSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
		let Center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
		let region: MKCoordinateRegion = MKCoordinateRegionMake(Center, aSpan)
		self.mapView!.setRegion(region, animated: true)
	}

	func loadPointsWithArray(somePhotos: [Photo]) {
		mapView!.removeAnnotations(mapView!.annotations)
		for i in 0..<somePhotos.count {
			let point: MapPointAnnotation = MapPointAnnotation()
			let v = somePhotos[i] as Photo
			point.venue = v
			let latitude = (v.lat as NSString).doubleValue
			let longitude = (v.lng as NSString).doubleValue
			point.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
			point.title = v.name
			point.subtitle = v.categoryName
			photoPoints[v.ident] = point
			mapView!.addAnnotation(point)
		}
	}

	// select venue from tableview
	func selectAnnotation(notification: NSNotification) {
		self.selectedVenue = notification.object as? Photo
		let point: MKPointAnnotation = photoPoints[self.selectedVenue!.ident]!
		mapView!.selectAnnotation(point, animated: true)
	}

	// select venue from mapview
	func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
		let p = view.annotation as! MapPointAnnotation
		self.selectedVenue = p.venue
		debugPrint("\(p.venue)")
	}

	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation {
			// return nil so map view draws "blue dot" for standard user location
			return nil
		} else {
			let reuseId = "pin"
			var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
			if pinView == nil {
				pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
				pinView!.canShowCallout = true
				pinView!.animatesDrop = true
				pinView!.pinTintColor = UIColor.purpleColor()
				if self.rightButton == nil {
					self.rightButton = UIButton(type: UIButtonType.DetailDisclosure)
				}
				// let point:MapPointAnnotation = pinView!.annotation as! MapPointAnnotation
				// println("point.venue.name = \(point.venue?.name)")
				// self.rightButton!.venue = point.venue
				self.rightButton!.titleForState(UIControlState.Normal)
				self.rightButton!.addTarget(self, action: #selector(MapViewController.rightButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
				pinView!.rightCalloutAccessoryView = self.rightButton! as UIView
			}
			else {
				pinView!.annotation = annotation
			}
			return pinView
		}
	}

	func rightButtonTapped(sender: UIButton!) {
		if let photo: Photo = selectedVenue {
			debugPrint("venue name:\(photo.name)")
			NSNotificationCenter.defaultCenter().postNotificationName("navigateToDetail", object: photo)
		} else {
			debugPrint("no photo")
		}
	}

}
