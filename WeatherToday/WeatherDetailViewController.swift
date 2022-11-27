//
//  WeatherDetailViewController.swift
//  WeatherToday
//
//  Created by 박다연 on 2022/11/26.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    
    var textToSet: String?
    var weatherToSet: String = ""
    var tempToset: String?
    var tempColor: String?
    var rainToset: String?
    var rainColor: Bool?
    
    // MARK: - viewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = textToSet
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.weatherImageView?.image = UIImage(named: weatherToSet)
        self.tempLabel?.text = tempToset
        self.rainLabel?.text = rainToset
        switch tempColor {
        case "blue":
            self.tempLabel.textColor = .systemBlue
        case "black":
            self.tempLabel.textColor = .black
        default:
            self.tempLabel.textColor = .systemRed
        }
        switch rainColor {
        case true:
            self.rainLabel.textColor = .systemOrange
        default:
            self.rainLabel.textColor = .black
        }
        
        switch weatherToSet {
        case "sunny":
            self.weatherLabel.text = "맑음"
        case "cloudy":
            self.weatherLabel.text = "흐림"
        case "rainy":
            self.weatherLabel.text = "비"
        case "snowy":
            self.weatherLabel.text = "눈"
        default:
            self.weatherLabel.text = ""
        }
    }
}
