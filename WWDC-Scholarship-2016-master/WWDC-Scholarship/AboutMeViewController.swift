//
//  AboutMeViewController.swift
//  WWDC-Scholarship
//
//  Created by Alex Hoppen on 12/04/16.
//  Copyright © 2016 Alex Hoppen. All rights reserved.
//

import UIKit
import MapKit

class AboutMeViewController: DetailViewController {
  @IBOutlet var mapView: MKMapView!
  let homeCoordinates = CLLocationCoordinate2DMake(50.967359, 6.831937)
  let aachenCoordinates = CLLocationCoordinate2DMake(50.770560, 6.096690)
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let coordinates = CLLocationCoordinate2DMake((homeCoordinates.latitude + aachenCoordinates.latitude)/2, (homeCoordinates.longitude + aachenCoordinates.longitude)/2)
    
    let homeAnnotation = MKPointAnnotation()
    homeAnnotation.coordinate = homeCoordinates
    mapView.addAnnotation(homeAnnotation)
    
    let aachenAnnotation = MKPointAnnotation()
    aachenAnnotation.coordinate = aachenCoordinates
    mapView.addAnnotation(aachenAnnotation)
    
    mapView.region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpanMake(1, 1))
  }
}