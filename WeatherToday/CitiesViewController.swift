//
//  CitiesViewController.swift
//  WeatherToday
//
//  Created by 박다연 on 2022/11/26.
//

import UIKit

class CitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var countryName: String?
    var assetName: String = ""
    
    @IBOutlet weak var citiesTableView: UITableView!
    
    let cellIdentifier: String = "cityCell"
    var citiesInfo: [Cities] = []
    
    var weatherImages: [String] = ["rainy", "snowy", "sunny","cloudy"]
    var weatherKr: [String] = ["비","눈","맑음","흐림"]

    // MARK: - viewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = countryName
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()

        citiesTableView.dataSource = self
        citiesTableView.delegate = self
        
        print(assetName)
        
        let jsonDecoder: JSONDecoder = JSONDecoder()
        guard let dataAsset: NSDataAsset = NSDataAsset(name: assetName) else { return }
        
        do {
            self.citiesInfo = try jsonDecoder.decode([Cities].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
        
        self.citiesTableView.reloadData()
    }
    
    // MARK: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = citiesTableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? CitiesTableViewCell else { return UITableViewCell() }
        
        let city: Cities = self.citiesInfo[indexPath.row]
        
        cell.cityNameLabel.text = city.cityName
        cell.tempLabel.text = city.temp
        cell.rainLabel.text = city.rain
        switch city.celsius {
        case ...10:
            cell.tempLabel.textColor = .systemBlue
        case ...25:
            cell.tempLabel.textColor = .black
        default:
            cell.tempLabel.textColor = .systemRed
        }
        switch city.rainfallProbability {
        case 0...50:
            cell.rainLabel.textColor = .black
        default:
            cell.rainLabel.textColor = .systemOrange
        }
        cell.accessoryType = .disclosureIndicator
        
        var weather: UIImage? {
            switch city.state {
            case 10:
                cell.weatherState = "sunny"
                return UIImage(named: "sunny")
            case 11:
                cell.weatherState = "cloudy"
                return UIImage(named: "cloudy")
            case 12:
                cell.weatherState = "rainy"
                return UIImage(named: "rainy")
            case 13:
                cell.weatherState = "snowy"
                return UIImage(named: "snowy")
            default:
                return nil
            }
        }
        cell.weatherImageView.image = weather
        
        return cell
    }
    
    // MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController: WeatherDetailViewController = segue.destination as? WeatherDetailViewController else {
            return
        }
        
        guard let cell: CitiesTableViewCell = sender as? CitiesTableViewCell else {
            return
        }
        
        nextViewController.textToSet = cell.cityNameLabel?.text
        nextViewController.tempToset = cell.tempLabel?.text
        if cell.tempLabel.textColor == .systemBlue {
            nextViewController.tempToset = cell.tempLabel?.text
            nextViewController.tempColor = "blue"
        } else if cell.tempLabel.textColor == .black {
            nextViewController.tempToset = cell.tempLabel?.text
            nextViewController.tempColor = "black"
        } else {
            nextViewController.tempToset = cell.tempLabel?.text
            nextViewController.tempColor = "red"
        }
        if cell.rainLabel.textColor == .systemOrange {
            nextViewController.rainToset = cell.rainLabel?.text
            nextViewController.rainColor = true
        } else {
            nextViewController.rainToset = cell.rainLabel?.text
            nextViewController.rainColor = false
        }
        nextViewController.weatherToSet = cell.weatherState
    }
}
