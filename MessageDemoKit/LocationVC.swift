//
//  LocationVC.swift
//  MessageDemoKit
//
//  Created by Emizen tech iMac  on 14/03/23.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol SetValue {
    func Location(lat : String,long: String)
}
extension SetValue {
    func Location(lat: String, long: String){
        
    }
}

class LocationVC: UIViewController,CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mapView: GMSMapView!
    
    // private var locationManager = CLLocationManager()
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    
    var delegate : SetValue? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deviceAuthenticat()
        // Initialize the location manager.

//        locationManager.distanceFilter = 50
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//
//        locationManager.delegate = self
//
//        locationManager.startMonitoringSignificantLocationChanges()
//
//        // Here you can check whether you have allowed the permission or not.
//
//        if CLLocationManager.locationServicesEnabled()
//        {
//            switch(CLLocationManager.authorizationStatus())
//            {
//
//            case .authorizedWhenInUse, .authorizedAlways:
//
//                print("Authorize.")
//
//                break
//
//            case .notDetermined:
//
//                print("Not determined.")
//
//                break
//
//            case .restricted:
//
//                print("Restricted.")
//
//                break
//
//            case .denied:
//
//                print("Denied.")
//            }
//        }
        
        let camera = GMSCameraPosition.camera(withLatitude: 23.931735,longitude: 121.082711, zoom: 7)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.mapView.addSubview(mapView)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -23.931735, longitude: 121.082711)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    
    func initLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func deviceAuthenticat(){
        
        if CLLocationManager.locationServicesEnabled(){
            switch locationManager.authorizationStatus {
            case .authorizedAlways,.authorizedWhenInUse:
                print("Location Authorized")
                self.initLocation()
                
                break
            case .notDetermined:
                print("Location Not Determined")
               
                break
            case .restricted:
                print("Location Restricted.")

                break
            case .denied:
                print("Location Denied")
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations
        
        print(location.first?.coordinate.latitude as Any)
        print(location.first?.coordinate.longitude as Any)
        
         
                    var lat = location.first?.coordinate.latitude as Any
                    var long = location.first?.coordinate.longitude as Any
        DispatchQueue.main.async { [self] in
            locationManager.stopUpdatingLocation()
         //   self.mapView.camera = GMSCameraPosition(target: location.first!.coordinate, zoom: 20, bearing: 0, viewingAngle: 0)
        }
                  //  delegate?.Location(lat : location.coordinate.latitude,long: location.coordinate.longitude)
                    delegate?.Location(lat: "\(lat)", long: "\(long)")
    }
}

// MARK: - CLLocationManagerDelegate

//extension LocationVC: CLLocationManagerDelegate {
//     func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
//        locationManager.stopUpdatingLocation()
//        //  removeLoadingView()
//        if (error) != nil {
//            print(error)
//        }
//    }
//     func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            locationManager.startUpdatingLocation()
//            mapView.isMyLocationEnabled = true
//            mapView.settings.myLocationButton = true
//        }
//    }
//
//
//
//    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//         print(manager.location?.coordinate.longitude)
//         print(manager.location?.coordinate.latitude)
//        if let location = locations.first {
//
//            /* you can use these values*/
//            var lat = location.coordinate.latitude
//            var long = location.coordinate.longitude
//
//            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 20, bearing: 0, viewingAngle: 0)
//
//            locationManager.stopUpdatingLocation()
//
//          //  delegate?.Location(lat : location.coordinate.latitude,long: location.coordinate.longitude)
//            delegate?.Location(lat: "\(lat)", long: "\(long)")
//        }
//    }
//
//
//}



