//
//  ViewController.swift
//  Main Weather
//
//  Created by Shemets on 19.05.22.
//

import UIKit
import CoreLocation
import AVFoundation

class ViewController: UIViewController { 
    
    var player: AVPlayer?
    
    private var collectionViewCount: [Current] = []
    private var tableViewCount: [Daily] = []
    
    private var customTabBarView = UIView()
    private var collectionView: UICollectionView!
    private var tableView: UITableView!
    private var locationManager = CLLocationManager()
    private var scrollView = UIScrollView()
    private var backgroundImageView = UIImageView()
    private var mainForecastView = UIView()
    private var hourlyForecastView = UIView()
    private var futureForecastView = UIView()
    private var nameCityLabel = UILabel()
    private var tempLabel = UILabel()
    private var textForecastLabel = UILabel()
    private var feelsLikeLabael = UILabel()
    private var imageViewForecast = UIImageView()
    private var windSpeedLabel = UILabel()
    private var humiditylLabel = UILabel()
    
    //41.6941100
    //44.8336800
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundVideo()
        //        setupBackground()
        setupScrollView()
        setupUI()
        setupUIMainForecast()
        setupUIHourlyForrecast()
        setupCollectionView()
        setupTableView()
        setupLocationManager()
        setupCustomTabBar()
        setupTabBarBattons()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height * 2)
        view.addSubview(scrollView)
    }
    
    private func setupBackgroundVideo() {
        let path = Bundle.main.path(forResource: "Background", ofType: "mp4")
        player = AVPlayer(url: URL(fileURLWithPath: path!))
        player!.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.insertSublayer(playerLayer, at: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
        player!.seek(to: CMTime.zero)
        player!.play()
        self.player?.isMuted = true
    }
    
    @objc func playerItemDidReachEnd() {
        player!.seek(to: CMTime.zero)
    }
    
    //    private func setupBackground() {
    //        backgroundImageView.frame = view.bounds
    //        backgroundImageView.image = UIImage(named: "ic_background2")
    //        backgroundImageView.contentMode = .scaleAspectFill
    //        view.addSubview(backgroundImageView)
    //    }
    
    private func setupUI() {
        let mainForecastWidth: CGFloat = view.bounds.width - 50
        let mainForecastHeight: CGFloat = view.bounds.height / 4
        mainForecastView.frame = CGRect(x: view.bounds.midX - mainForecastWidth / 2,
                                        y: view.bounds.midY - mainForecastHeight * 2.1,
                                        width: mainForecastWidth,
                                        height: mainForecastHeight)
        mainForecastView.backgroundColor = .clear
        mainForecastView.layer.cornerRadius = 15
        scrollView.addSubview(mainForecastView)
        
        
        hourlyForecastView.frame = mainForecastView.frame.offsetBy(dx: 0, dy: mainForecastHeight / 1.2)
        hourlyForecastView.backgroundColor = .systemGray5
        hourlyForecastView.alpha = 0.7
        hourlyForecastView.layer.cornerRadius = 15
        scrollView.addSubview(hourlyForecastView)
        
        futureForecastView.frame = hourlyForecastView.frame.offsetBy(dx: 0, dy: mainForecastHeight + 20)
        let futureViewWidth: CGFloat = view.bounds.width - 50
        let futereViewHeight: CGFloat = view.bounds.height / 2.9
        futureForecastView.frame.size = CGSize(width: futureViewWidth, height: futereViewHeight)
        futureForecastView.backgroundColor = .clear
        futureForecastView.alpha = 0.7
        futureForecastView.layer.cornerRadius = 15
        scrollView.addSubview(futureForecastView)
    }
    
    private func setupUIMainForecast() {
        let labelWidth: CGFloat = mainForecastView.bounds.width
        let labelHeight: CGFloat = 50
        nameCityLabel.frame = CGRect(x: mainForecastView.bounds.midX - labelWidth / 2,
                                     y: mainForecastView.bounds.minY,
                                     width: labelWidth,
                                     height: labelHeight)
        nameCityLabel.text = "Loading.."
        nameCityLabel.font = .boldSystemFont(ofSize: 35)
        nameCityLabel.textAlignment = .center
        nameCityLabel.textColor = .white
        nameCityLabel.backgroundColor = .clear
        mainForecastView.addSubview(nameCityLabel)
        
        let tempWidth: CGFloat = mainForecastView.bounds.width
        let tempHeight: CGFloat = 60
        tempLabel.frame = nameCityLabel.frame.offsetBy(dx: labelWidth / 25, dy: labelHeight)
        tempLabel.frame.size = CGSize(width: tempWidth, height: tempHeight)
        tempLabel.backgroundColor = .clear
        tempLabel.text = "Loading.."
        tempLabel.textColor = .white
        tempLabel.font = .systemFont(ofSize: 80)
        mainForecastView.addSubview(tempLabel)
        
        let imageWidth: CGFloat = 100
        let imageHeight: CGFloat = 100
        imageViewForecast.frame = CGRect(x: mainForecastView.bounds.midX + imageWidth / 2,
                                         y: mainForecastView.bounds.minY + imageHeight / 1.6,
                                         width: imageWidth,
                                         height: imageHeight)
        imageViewForecast.backgroundColor = .clear
        mainForecastView.addSubview(imageViewForecast)
        
        textForecastLabel.frame = tempLabel.frame.offsetBy(dx: 10, dy: labelHeight)
        textForecastLabel.backgroundColor = .clear
        textForecastLabel.textColor = .white
        textForecastLabel.font = .systemFont(ofSize: 25)
        //        textForecastLabel.textAlignment = .center
        mainForecastView.addSubview(textForecastLabel)
        
        feelsLikeLabael.frame = textForecastLabel.frame.offsetBy(dx: 0, dy: labelHeight / 2)
        feelsLikeLabael.textColor = .white
        feelsLikeLabael.font = .systemFont(ofSize: 22)
        //        feelsLikeLabael.textAlignment = .center
        mainForecastView.addSubview(feelsLikeLabael)
        
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: hourlyForecastView.bounds.width / 3 - 7,
                                     height: hourlyForecastView.bounds.width / 3 - 7)
        let collectionViewWidth: CGFloat = hourlyForecastView.bounds.width
        let collectionViewHeight: CGFloat = hourlyForecastView.bounds.height
        let collectionViewFrame = CGRect(x: hourlyForecastView.bounds.midX - collectionViewWidth / 2,
                                         y: hourlyForecastView.bounds.midY - collectionViewHeight / 3,
                                         width: collectionViewWidth,
                                         height: collectionViewHeight / 1.5)
        self.collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: flowLayout)
        collectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        hourlyForecastView.addSubview(collectionView)
    }
    
    private func setupUIHourlyForrecast() {
        let labelWidth: CGFloat = hourlyForecastView.bounds.width - 20
        let labelHeigth: CGFloat = hourlyForecastView.bounds.height / 6
        humiditylLabel.frame = CGRect(x: hourlyForecastView.bounds.midX - labelWidth / 2,
                                      y: hourlyForecastView.bounds.maxY - labelHeigth * 1.1,
                                      width: labelWidth,
                                      height: labelHeigth)
        humiditylLabel.text = "loading.."
        humiditylLabel.textAlignment = .center
        humiditylLabel.backgroundColor = .clear
        hourlyForecastView.addSubview(humiditylLabel)
        
        windSpeedLabel.frame = CGRect(x: hourlyForecastView.bounds.midX - labelWidth / 2,
                                      y: hourlyForecastView.bounds.minY + labelHeigth / 10,
                                      width: labelWidth,
                                      height: labelHeigth)
        windSpeedLabel.text = "loading.."
        windSpeedLabel.textAlignment = .center
        windSpeedLabel.backgroundColor = .clear
        hourlyForecastView.addSubview(windSpeedLabel)
    }
    
    
    private func setupTableView() {
        self.tableView = UITableView()
        let tableViewWidth: CGFloat = futureForecastView.bounds.width
        let tableViewHeigth: CGFloat = futureForecastView.bounds.height
        tableView.frame = CGRect(x: futureForecastView.bounds.midX - tableViewWidth / 2,
                                 y: futureForecastView.bounds.midY - tableViewHeigth / 2,
                                 width: tableViewWidth,
                                 height: tableViewHeigth)
        tableView.register(DailyTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.layer.cornerRadius = 15
        tableView.dataSource = self
        tableView.delegate = self
        futureForecastView.addSubview(tableView)
    }
    
    private func setupCustomTabBar() {
        let tabBarWidth: CGFloat = view.bounds.width
        let tabBarHeigth: CGFloat = view.bounds.height / 12
        customTabBarView.frame = CGRect(x: view.bounds.midX - tabBarWidth / 2,
                                    y: view.bounds.maxY - tabBarHeigth,
                                    width: tabBarWidth,
                                    height: tabBarHeigth)
        customTabBarView.backgroundColor = .systemGray4
        view.addSubview(customTabBarView)
    }
    
    private func setupTabBarBattons() {
        let searchButton = UIButton()
        let searchButtonWidth: CGFloat = 40
        let searchButtonawHeight: CGFloat = 40
        searchButton.frame = CGRect(x: customTabBarView.bounds.maxX - searchButtonWidth * 1.5,
                                    y: customTabBarView.bounds.minY + 8,
                                    width: searchButtonWidth,
                                    height: searchButtonawHeight)
        searchButton.setImage(UIImage(named: "plus"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonClecked), for: .touchUpInside)
        customTabBarView.addSubview(searchButton)
        
        let mapButton = UIButton()
        mapButton.frame = searchButton.frame.offsetBy(dx: -searchButtonWidth * 8.6, dy: 0)
        mapButton.setImage(UIImage(named: "map"), for: .normal)
        mapButton.addTarget(self, action: #selector(mapButtonClicked), for: .touchUpInside)
        customTabBarView.addSubview(mapButton)
    }
    
    @objc private func searchButtonClecked() {
        transitToSearchViewController()
    }
    
    @objc private func mapButtonClicked() {
        transitToMapLocationViewController()
    }
    
    private func transitToSearchViewController() {
        let storyboard = UIStoryboard(name: "SearchViewController", bundle: Bundle.main)
        let searchVC = storyboard.instantiateInitialViewController() as! SearchViewController
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    private func transitToMapLocationViewController() {
        let storyboard = UIStoryboard(name: "MapLocationScreen", bundle: Bundle.main)
        let mapLocationVC = storyboard.instantiateInitialViewController() as! MapLocationViewController
        navigationController?.pushViewController(mapLocationVC, animated: true)
    }
    
    private func updateUI(responce: WeatherResponse) {
        // MainForecastView
        let nameCity = responce.timezone
        let temp = responce.current.temp
        let icon = UIImage(named: responce.current.weather[0].icon)
        let description = responce.current.weather[0].weatherDescription
        let feelsLike = responce.current.feelsLike
        nameCityLabel.text = nameCity
        tempLabel.text = "\(String(Int(temp)))°"
        imageViewForecast.image = icon
        textForecastLabel.text = "\(description)"
        feelsLikeLabael.text = "Feels Like \(String(Int(feelsLike)))°"
        
        // HourlyForecastView
        let humidity = responce.current.humidity
        let windSpeed = responce.current.windSpeed
        // CollectionViewData - Count
        self.collectionViewCount = responce.hourly
        self.collectionView.reloadData()
        // TableViewData - Count
        self.tableViewCount = responce.daily
        self.tableView.reloadData()
        humiditylLabel.text = "Humidity: \(String(Int(humidity))) %"
        windSpeedLabel.text = "Wind Speed: \(String(Int(windSpeed))) m/s"
    }
    
    private func setupLocationManager() {
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
//            locationManager.pausesLocationUpdatesAutomatically = false
//            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        }
    }
    
    private func updateWeatherInfo(latitude : Double, longtitude : Double) {
        let stringURL = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longtitude)&exclude=minutely&appid=8f1bd7e940447af928cf9025cae58514&units=metric"
          
        guard let url = URL(string: stringURL) else {
           assertionFailure("url is nil")
            return
        }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
            }
            if let data = data {
                let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)
                print(weatherResponse)
                guard let weatherResponse = weatherResponse else {
                    return
                }
                DispatchQueue.main.async { [self] in
                    updateUI(responce: weatherResponse)
                }
            }
        }
        task.resume() 
    }
    
}


extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longtitude: lastLocation.coordinate.longitude)
//            print(locations)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCount.count / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HourlyCollectionViewCell
        cell.configure(with: collectionViewCount[indexPath.row])
        cell.backgroundColor = .systemGray5
        cell.layer.cornerRadius = 15
        return cell
    }
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DailyTableViewCell
        cell.configure(with: tableViewCount[indexPath.row])
        cell.backgroundColor = .clear
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = indexPath.row % 2 == 0 ? 40 : 40
        return height
    }
    
}
