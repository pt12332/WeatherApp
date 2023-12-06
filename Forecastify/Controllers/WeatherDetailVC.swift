//
//  WeatherDetailVC.swift
//  Forecastify
//
//  Created by DREAMWORLD on 30/11/23.
//

import UIKit
import CoreLocation

class WeatherDetailVC: UIViewController {
    
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblWeather: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var tbl_weather: UITableView!
    
    lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.distanceFilter = 10
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    var arrWeather = [DailyData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // requtest fro location service access permission popup
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        getWeatherDetail()
        getAddressFromLatLon()
    }
    
    //MARK: Calling Web API for get weather detail of current location
  
    func getWeatherDetail(){
        
        if let location = locationManager.location {
            
            let coordinate = location.coordinate
            
            let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&exclude=minutely&appid=cc899157f374994317d6f1068339c300&units=imperial"
            
            let task = URLSession.shared.dataTask(with: URLRequest(url: URL(string: url)!)) { [self] data, response, error in
                
                if let error = error {
                    
                    print("error:",error.localizedDescription)
                    return
                }
                
                DispatchQueue.main.async { [self] in
                    
                    if let data = data {
                        
                        do {
                            
                            let responseData = try JSONSerialization.jsonObject(with: data,options: .mutableContainers) as? [String:Any]
//                            print("responseData:",responseData)
                            
                            if let currentData = responseData?["current"] as? [String:Any] {
                                
                                print("currentData:",currentData)
                                
                                if let weatherAry = currentData["weather"] as? [[String:Any]] {
                                    
                                    let main = weatherAry[0]["main"] as? String
                                    self.lblWeather.text = main
                                }
                                
                                let temp = currentData["temp"] as? Double ?? 0.0
                                let dt = currentData["dt"] as? Int ?? 0
                                
                                let epocTime = TimeInterval(dt)
                                let myDate = NSDate(timeIntervalSince1970: epocTime)
                                print("Converted Time \(myDate)")
                                
                                //    ********* day
                                
                                let dateFormatter = DateFormatter()
                                var weekday: String = ""
                                dateFormatter.dateFormat = "cccc"
                                weekday = dateFormatter.string(from: myDate as Date)
                                
                                //  ******** month
                                
                                dateFormatter.dateFormat = "MM"
                                let date1 = dateFormatter.string(from: myDate as Date)
                                print("date:::::," ,date1)
                                
                                //  ******** day
                                
                                dateFormatter.dateFormat = "dd"
                                let date2 = dateFormatter.string(from: myDate as Date)
                                print("date:::::," ,date2)
                                
                                self.lblTemp.text = "\(temp.getString())"
                                self.lblDay.text = weekday
                                self.lblMonth.text = date1
                                self.lblDate.text = date2
                            }
                            
                            // table list data
                            if let daily = responseData?["daily"] as? [[String:Any]] {
                                
                                arrWeather.removeAll()
                                
                                for value in daily {
                                    
                                    let dt = value["dt"] as? Int ?? 0
                                    var min = 0.0
                                    var max = 0.0
                                    
                                    if let temp =  value["temp"] as? [String:Any] {
                                        
                                        min = temp["min"] as? Double ?? 0.0
                                        max = temp["max"] as? Double ?? 0.0
                                    }
                                    
                                    var icon = ""
                                    
                                    if let weatherAry = value["weather"] as? [[String:Any]] {
                                        
                                        icon = weatherAry[0]["icon"] as? String ?? ""
                                    }
                                    
                                    print("min:",min)
                                    print("max:",max)
                                    print("dt:",dt)
                                    print("icon:",icon)
                                    
                                    let epocTime = TimeInterval(dt)
                                    let myDate = NSDate(timeIntervalSince1970: epocTime)
                                    
                                    let dateFormatter1 = DateFormatter()
                                    var weekday: String = ""
                                    dateFormatter1.dateFormat = "cccc"
                                    weekday = dateFormatter1.string(from: myDate as Date)
                                    
                                    arrWeather.append(DailyData( max: max, min: min, dt: weekday, icon: icon))
                                }
                                
                                tbl_weather.reloadData()
                            }
                        }
                        catch
                        {
                            print("JSON convert error:",error.localizedDescription)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    //MARK: - fetch currunt city from current latitude and longitude
    
    func getAddressFromLatLon(){
        
        if let location = locationManager.location {
            
            let coordinate = location.coordinate
            
            let lat: Double = coordinate.latitude
            let lon: Double = coordinate.longitude
            var city : String = ""
            
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            center.latitude = lat
            center.longitude = lon
            
            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
            
            let ceo: CLGeocoder = CLGeocoder()
            ceo.reverseGeocodeLocation(loc, completionHandler:
                                        {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    
                    let pm = placemarks![0]
                    
                    print("sub locality",pm.subLocality as Any)
                    
                    if pm.subLocality != nil {
                        
                        city = pm.subLocality!
                        self.lblCity.text = city
                    }
                }
            })
        }
    }
}

extension WeatherDetailVC : CLLocationManagerDelegate {
    
    // call when location authorization status changed
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if (status == .authorizedWhenInUse || status == .authorizedAlways)
        {
            locationManager.startUpdatingLocation()
            getWeatherDetail()
            getAddressFromLatLon()
        }
    }
}

//table view delegate methods

extension WeatherDetailVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTblCell", for: indexPath) as! WeatherTblCell
        
        cell.bg_view.layer.cornerRadius = 10
        cell.bg_view.setdropShado()
        
        let data = arrWeather[indexPath.row]
        
        cell.lbl_day.text = data.dt
        cell.lbl_max.text = data.max.getString()
        cell.lbl_min.text = data.min.getString()
        
        let imageURL = URL(string: "http://openweathermap.org/img/w/\(data.icon).png")!
        cell.downloadImage(from: imageURL)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
