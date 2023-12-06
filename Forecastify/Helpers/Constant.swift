import Foundation
import UIKit

// for use custom font anywhere in app
struct Poppins {
    
    static let bold = "Poppins-Bold"
    static let medium = "Poppins-Medium"
    static let regular = "Poppins-Regular"
    static let semibold = "Poppins-Semibold"
}

// structure for storing weather data from api response and using it to show weather data in table list
struct DailyData {
    
    var icon : String
    var max : Double
    var min : Double
    var dt : String
    
    init( max : Double,min : Double,dt : String,icon : String){
      
        self.icon = icon
        self.max = max
        self.min = min
        self.dt = dt
    }
}


// use this for apply shadow to any UI component
extension UIView {
    
    func setdropShado() {
           
           let layer = self.layer
           layer.shadowColor = UIColor.lightGray.cgColor
           layer.shadowOffset = CGSize(width: 0.0, height: 1)
           layer.shadowOpacity = 3.0
           layer.shadowRadius = 3.0
           layer.masksToBounds = false
       }
}

// get string from double with fahrenheit symbol

extension Double {
    
    func getString() -> String {
        "\(String(format: "%.0f", self)) °F"
    }
}
