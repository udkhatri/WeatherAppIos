//
//  ViewController.swift
//  Lab3
//
//  Created by Uday Khatri on 2022-07-19.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var SearchStack: UIStackView!
    @IBOutlet var MainView: UIView!
    @IBOutlet weak var dayNightLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var weartherConditionText: UILabel!
    
    @IBOutlet weak var dayNightImage: UIImageView!
    var weatherIcon = [1000 : "sun.max",
                       1003 : "smoke",
                       1006 : "cloud",
                       1009 : "cloud",
                       1030 : "cloud.fog",
                       1063 : "cloud.drizzle",
                       1066 : "cloud.snow",
                       1069 : "cloud.sleet",
                       1072 : "cloud.snow",
                       1087 : "cloud.bolt.rain",
                       1114 : "cloud.snow",
                       1117 : "wind.snow",
                       1135 : "smoke",
                       1147 : "cloud.fog",
                       1150 : "cloud.drizzle",
                       1153 : "cloud.drizzle",
                       1168 : "cloud.sleet",
                       1171 : "cloud.sleet",
                       1180 : "cloud.drizzle",
                       1183 : "cloud.drizzle",
                       1186 : "cloud.drizzle",
                       1189 : "cloud.drizzle",
                       1192 : "cloud.bolt.rain",
                       1195 : "cloud.bolt.rain",
                       1198 : "cloud.sleet",
                       1201 : "cloud.sleet",
                       1204 : "cloud.sleet",
                       1207 : "cloud.sleet",
                       1210 : "thermometer.snowflake",
                       1213 : "thermometer.snowflake",
                       1216 : "thermometer.snowflake",
                       1219 : "thermometer.snowflake",
                       1222 : "snowflake.circle",
                       1225 : "snowflake.circle",
                       1237 : "snowflake",
                       1240 : "cloud.sun.rain",
                       1243 : "cloud.heavyrain",
                       1246 : "cloud.bolt.rain",
                       1249 : "cloud.sleet",
                       1252 : "cloud.sleet",
                       1255 : "cloud.snow",
                       1258 : "snowflake",
                       1261 : "snowflake",
                       1264 : "snowflake",
                       1273 : "cloud.sun.bolt",
                       1276 : "cloud.bolt.rain",
                       1279 : "cloud.bolt.rain",
                       1282 : "wind.snow",
    ]
    var Imageconfig = UIImage.SymbolConfiguration(paletteColors: [
        .systemYellow,
        .lightGray,
    ])
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        locationManager.delegate = self
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.systemGray4.cgColor
        searchBar.layer.cornerRadius = 5
        SearchStack.layer.cornerRadius = 9
        SearchStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        getCurrentLocation()
    }
   
    func getCurrentLocation(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        loadWeather(search: searchBar.text)
        return true
    }
    func weatherImageDisplay(code: Int, dayNight:Int){
        DispatchQueue.main.async {
            self.weatherConditionImage.preferredSymbolConfiguration = self.Imageconfig
            if code == 1000 && dayNight == 0 {
                self.weatherConditionImage.image = UIImage(systemName: "moon")
            }else{
                self.weatherConditionImage.image = UIImage(systemName: self.weatherIcon[code] ?? "")
            }
        }

    }
    @IBAction func locationButton(_ sender: UIButton) {
        getCurrentLocation()
        print("Hello")
    }
    
    @IBAction func searchButton(_ sender: Any) {
        loadWeather(search: searchBar.text)
        
    }
    
    func loadWeather(search: String?){
        guard let search = search else {
            return
        }
        DispatchQueue.main.async {
            self.searchBar.text = ""
        }
        let url = getURL(query: search)
        guard let url = url else {
            return
        }
        print(url)
        let session = URLSession.shared

        let dataTask = session.dataTask(with: url) { data, response, error in
            print("call complete")
            guard error == nil else {
                print("There's an error")
                return
            }

            guard let data = data else {
                return
            }

            if let weatherResponse = self.parseJson(data: data){
                print(weatherResponse.location.name)
                print(weatherResponse.current.condition.code)
                self.weatherImageDisplay(code: weatherResponse.current.condition.code, dayNight: weatherResponse.current.condition.code)
                self.dayNightThemeSetter(day: weatherResponse.current.is_day)
                DispatchQueue.main.async {
                    self.locationLabel.text = weatherResponse.location.name
                    self.tempLabel.text = "\(Int(weatherResponse.current.temp_c)) C°"
                    self.timeLabel.text = weatherResponse.location.localtime
                    self.weartherConditionText.text = weatherResponse.current.condition.text
                }
            }

        }
        dataTask.resume()
    }
 
    private func dayNightThemeSetter(day: Int?){
        guard let day = day else {
            return
        }
        DispatchQueue.main.async {
            if day == 0 {
                let Imageconfig2 = UIImage.SymbolConfiguration(paletteColors: [
                    .systemYellow,
                    .white,
                ])
                self.MainView.backgroundColor = UIColor.black
                self.dayNightImage.preferredSymbolConfiguration = Imageconfig2
                self.dayNightImage.image = UIImage(systemName: "moon.circle.fill")
                self.dayNightLabel.text = "Night"
                self.SearchStack.backgroundColor = UIColor.systemGray5
                self.searchBar.backgroundColor = UIColor.systemGray6
                self.searchBar.textColor = UIColor.white
                self.searchBar.tintColor = UIColor.gray
                self.searchBar.layer.borderColor = UIColor.systemGray4.cgColor
                self.tempLabel.textColor = UIColor.white
                self.dayNightLabel.textColor = UIColor.white
                self.weartherConditionText.textColor = UIColor.white
                self.timeLabel.textColor = UIColor.white
                self.locationLabel.textColor = UIColor.white
            }
            else{
                let Imageconfig2 = UIImage.SymbolConfiguration(paletteColors: [
                    .systemYellow,
                    .black
                ])
                self.MainView.backgroundColor = UIColor.white
                self.dayNightImage.preferredSymbolConfiguration = Imageconfig2
                self.dayNightLabel.text = "Day"
                self.searchBar.textColor = UIColor.black
                self.SearchStack.backgroundColor = UIColor.lightGray
                self.searchBar.backgroundColor = UIColor.white
                self.searchBar.tintColor = UIColor.gray
                self.dayNightImage.image = UIImage(systemName: "sun.max.circle.fill")
                self.searchBar.backgroundColor = UIColor.white
                self.searchBar.layer.borderColor = UIColor.systemGray.cgColor
                self.tempLabel.textColor = UIColor.black
                self.dayNightLabel.textColor = UIColor.black
                self.weartherConditionText.textColor = UIColor.black
                self.timeLabel.textColor = UIColor.black
                self.locationLabel.textColor = UIColor.black
            }
        }
       
       
    }
    private func getURL(query: String) -> URL?{
        let baseUrl = "https://api.weatherapi.com/v1/"
        let currentEndpoint = "current.json"
        let key = "def46fe96f3b486e86d12658222007"
        
        guard let url =
            "\(baseUrl)\(currentEndpoint)?key=\(key)&q=\(query)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return nil
            }
        print(url)
        return URL(string: url)
    }
    
    private func parseJson(data: Data) -> WeatherResponse? {
        let decoder = JSONDecoder()
        var weather: WeatherResponse?
        do{
            weather = try decoder.decode(WeatherResponse.self, from: data)
        }
        catch{
            print("Error")
        }
        
        return weather
    }
}
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            loadWeather(search: "\(latitude),\(longitude)")
            print("latitude is: \(latitude),\(longitude)")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
struct WeatherResponse: Decodable {
    let location: Location
    let current: WeatherTemp
}
struct Location: Decodable {
    let name: String
    let localtime: String
}
struct WeatherTemp: Decodable {
    let temp_c: Float
    let temp_f: Float
    let condition: WeatherCondition
    let is_day: Int
}
struct WeatherCondition: Decodable{
    let text: String
    let code: Int
}
