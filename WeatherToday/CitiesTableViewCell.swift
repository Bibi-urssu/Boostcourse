//
//  CitiesTableViewCell.swift
//  WeatherToday
//
//  Created by 박다연 on 2022/11/26.
//

import UIKit

class CitiesTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    var weatherState: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
