//
//  CountriesViewController.swift
//  WeatherToday
//
//  Created by 박다연 on 2022/11/26.
//

import UIKit

class CountriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var countriesTableView: UITableView!
    let cellIdentifier: String = "countryCell"
    
    var countries: [Countries] = []
    
    // MARK: - tableView dateSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = countriesTableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? CountriesTableViewCell else { return UITableViewCell() }
        
        let country: Countries = self.countries[indexPath.row]
        
        cell.textLabel?.text = country.koreanName
        cell.imageView?.image = UIImage(named: country.assetFullName)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countriesTableView.delegate = self
        countriesTableView.dataSource = self
        
        let jsonDecoder: JSONDecoder = JSONDecoder()
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "countries") else {
            return
        }
        
        do {
            self.countries = try jsonDecoder.decode([Countries].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
        
        self.countriesTableView.reloadData()
    }
    
    // MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController: CitiesViewController = segue.destination as? CitiesViewController else { return }
        
        guard let cell: UITableViewCell = sender as? UITableViewCell else { return }
        
        nextViewController.countryName = cell.textLabel?.text
        switch cell.textLabel?.text {
        case "한국":
            nextViewController.assetName = "kr"
        case "독일":
            nextViewController.assetName = "de"
        case "이탈리아":
            nextViewController.assetName = "it"
        case "미국":
            nextViewController.assetName = "us"
        case "프랑스":
            nextViewController.assetName = "fr"
        case "일본":
            nextViewController.assetName = "jp"
        default:
            return
        }
    }
    
    // MARK: - deselectRow
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
