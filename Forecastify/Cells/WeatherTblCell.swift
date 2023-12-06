import UIKit

class WeatherTblCell: UITableViewCell {
    
    @IBOutlet weak var lbl_day: UILabel!
    @IBOutlet weak var lbl_min: UILabel!
    @IBOutlet weak var lbl_max: UILabel!
    @IBOutlet weak var img_weather: UIImageView!
    @IBOutlet weak var bg_view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // for sonwload weather sumbol image from url and set it ti image view
    
    func downloadImage(from url: URL) {
        
            URLSession.shared.dataTask(with: url) { data, _, error in
                
                if let error = error {
                    
                    print("Error downloading image: \(error)")
                    return
                }

                if let data = data {
                    
                    DispatchQueue.main.async {
                        
                        self.img_weather.image = UIImage(data: data)
                    }
                }
            }.resume()
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
