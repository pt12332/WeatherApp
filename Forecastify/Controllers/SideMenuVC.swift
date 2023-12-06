
import UIKit

class SideMenuVC: UITableViewController  {

    @IBOutlet var tbl_option: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
      
        var configuration = UIListContentConfiguration.cell()
        
        if indexPath.row == 0 {
            
            configuration.text = "Weather"
            configuration.image = UIImage(named: "ic_weather")
        }
        else
        {
            configuration.text = "Map and Location"
            configuration.image = UIImage(named: "ic_map")
            configuration.image = UIImage(named: "ic_map")
        }
        
        configuration.textProperties.font = UIFont(name: Poppins.regular, size: 16)!
        cell.contentConfiguration = configuration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            self.performSegue(withIdentifier: "showWeatherDetails", sender: self)
        }
        else
        {
            self.performSegue(withIdentifier: "showMapLocation", sender: self)
        }
    }
  
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
}
