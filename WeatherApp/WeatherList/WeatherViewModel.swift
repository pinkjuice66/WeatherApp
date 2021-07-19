import UIKit

class WeatherViewModel {
    
    static let shared = WeatherViewModel()
    
    private var cities: [City] = []
    var isUpdateNeeded: Bool = false
    
    // 네트워크에 연결되어지지 않았을 경우 뛰우는 알림창
    let alertController: UIAlertController = {
        let defaultAction = UIAlertAction(title: "OK",
                                style: .default) { (action) in
            // Respond to user selection of the action.
           }
        let settingsAction = UIAlertAction(title: "Settings",
                                style: .default) { (action) in
            // Respond to user selection of the action.
        }
           
        let alert = UIAlertController(title: "Cellular Data is Turned Off",
                                      message: "Turn on cellular data or use WI-FI to access data",
                                      preferredStyle: .alert)
        alert.addAction(defaultAction)
        alert.addAction(settingsAction)
        return alert
    }()
    
    init() {
        retrieveCities()
        addNetworkConnectedObserver()
    }
    
    // 네트워크가 다시 연결되었고 날씨 정보를 업데이트 해야하면 업데이트 한다.
    private func addNetworkConnectedObserver() {
        let notificationName = NSNotification.Name("networkConnected")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateCheck),
                                               name: notificationName, object: nil)
    }
    
        
    // 디스크에 저장되어 있는 cities json 파일을 읽어와서 cities에 담는다.
    private func retrieveCities() {
        let names = Storage.getCityNames()
        cities = []
    
        for name in names {
            if let city = Storage.retrive(name, as: City.self) {
                cities.append(city)
            }
        }
        cities.sort(by: <)
    }
    
    func getCities() -> [City] {
        return cities
    }
    
    func addCity(cityName: String, latitude: String,
                 longitude: String) {
        WeatherAPI.getWeatherInfo(cityName: cityName,
                                  latitude: latitude,
                                  longitude: longitude) { city in
            if self.cities.contains(city) { return }
            self.store(city)
            self.cities.append(city)
            // 날씨 정보가 도착하면 Notification을 날려서 WeatherList의 table view를 업데이트
            let notificationName = NSNotification.Name("weatherInfoArrived")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }
    
    func removeCity(_ city: City) {
        Storage.remove(city.name)
        
        if let idx = cities.firstIndex(of: city) {
            cities.remove(at: idx)
        }
    }
    
    // 유지하고 있는 도시목록 중에 업데이트한 시간이 n분이 지난 경우 업데이트
    @objc func updateCheck(within n: Int = 30) {
        let deadLine = Double(n) * 60
        for city in getCities() {
            let timeInterval = Date().timeIntervalSince1970 - city.updatedDate.timeIntervalSince1970
            if timeInterval >= deadLine {
                updateWeather(of: city)
            }
        }
    }
    
    // 도시의 기상 정보를 업데이트 시킨다.
    private func updateWeather(of city: City) {
        // 네트워크 연결이 되어있지 않은 경우 WeatherListViewController에서 경고창이 뜰 수 있도록 Notification을 보낸다.
        guard NetworkConnectionMonitor.shared.isConnected() else {
            isUpdateNeeded = true
            let notificationName = NSNotification.Name(rawValue: "networkIsntConnected")
            NotificationCenter.default.post(name: notificationName,
                                                object: alertController)
            return
        }
        
        WeatherAPI.getWeatherInfo(cityName: city.name,
                                  latitude: city.latitude, longitude: city.longitude)
        { city in
            self.store(city)
            guard let idx = self.cities.firstIndex(of: city) else { return }
            DispatchQueue.main.async {
                self.cities[idx] = city
                let notificationName = NSNotification.Name("weatherInfoArrived")
                NotificationCenter.default.post(name: notificationName,
                                                object: nil)
            }
        }
    }
    
    // 입력된 도시를 json 형태로 저장
    private func store(_ city: City) {
        Storage.store(city, as: city.name)
    }
    
}
