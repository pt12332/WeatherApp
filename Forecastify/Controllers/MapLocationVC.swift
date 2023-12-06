import UIKit
import MapKit
import CoreLocation

class MapLocationVC: UIViewController {
    
    @IBOutlet weak var map_view: MKMapView!
    @IBOutlet weak var btn_currentLocation: UIButton!
    
    lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.distanceFilter = 10
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    let currentLocationPoint = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // requtest fro location service access permission popup
        btn_currentLocation.layer.cornerRadius = 10
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    // To set any location point centered in map view
    
    func updateLocationonMap(to location: CLLocation, with title: String?)
    {
        currentLocationPoint.title = title
        currentLocationPoint.coordinate = location.coordinate
        self.map_view.addAnnotation(currentLocationPoint)
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        self.map_view.setRegion(region, animated: true)
    }
    
    @IBAction func click_onCurrentLocation(_ sender: Any) {
        
        updateLocationonMap(to: locationManager.location ?? CLLocation(), with: "Current Location")
    }
}

extension MapLocationVC : CLLocationManagerDelegate {
    
    // call when location authorization status changed
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if (status == .authorizedWhenInUse || status == .authorizedAlways)
        {
            locationManager.startUpdatingLocation()
            updateLocationonMap(to: locationManager.location ?? CLLocation(), with: "Current Location")
        }
    }
}
