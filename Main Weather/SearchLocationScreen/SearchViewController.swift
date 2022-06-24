//
//  SearchViewController.swift
//  Main Weather
//
//  Created by Shemets on 24.05.22.
//
// http://api.openweathermap.org/geo/1.0/direct?q=London&limit=5&appid=8f1bd7e940447af928cf9025cae58514
import UIKit

class SearchViewController: UIViewController {
    
//    var latitudeSelected: Double = 0
//    var longitudeSelected: Double = 0
    let networkService = NetworkService()
    var searchResponseElement: [SearchResponseElement]? = nil
    private var timer: Timer?
    private var searchTableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .white

      setupSearchController()
        setupSearchTableView()
}
        
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
         }
    
    private func setupSearchTableView() {
        self.searchTableView = UITableView()
        let tableWidth: CGFloat = view.bounds.width - 50
        let tableHeight: CGFloat = view.bounds.height
        searchTableView.frame = searchController.accessibilityFrame.offsetBy(dx: 15, dy: 50)
        searchTableView.frame.size = CGSize(width: tableWidth, height: tableHeight)
        searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        searchTableView.layer.cornerRadius = 10
        searchTableView.backgroundColor = .white
//        searchTableView.alpha = 0.8
        searchTableView.delegate = self
        searchTableView.dataSource = self
        view.addSubview(searchTableView)
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponseElement?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .clear
        let place = searchResponseElement?[indexPath.row]
        guard let place = place else {
            return cell 
        }
        cell.textLabel?.text = "\(place.name), \(place.country)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let indexPath = indexPath.row
        guard let searchResponseElement = searchResponseElement else {
            return
        }
        let latitudeSelected = searchResponseElement[indexPath.row].lat
        let longitudeSelected = searchResponseElement[indexPath.row].lon
        
             let storyboard = UIStoryboard(name: "FoundPlaceViewController", bundle: Bundle.main)
             let foundVC = storyboard.instantiateInitialViewController() as! FoundPlaceViewController
        foundVC.latitude = latitudeSelected
        foundVC.longitude = longitudeSelected
        present(foundVC, animated: true)
        
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let stringURLSearch = "https://api.openweathermap.org/geo/1.0/direct?q=\(searchText)&limit=5&appid=8f1bd7e940447af928cf9025cae58514"
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
            self.networkService.request(stringURLSearch: stringURLSearch) { [weak self] (result) in
                switch result {
                case .success(let searchResponseElement):
                    self?.searchResponseElement = searchResponseElement
                    self?.searchTableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        })
    }
}

