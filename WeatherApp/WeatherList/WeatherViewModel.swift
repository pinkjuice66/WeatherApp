// 가지고 있어야 하는 정보 : 저장된 도시에 대한 날씨 정보

import UIKit

class WeatherViewModel {
    
    static let shared = WeatherViewModel()
    
    private var cities: [City] = []
    
    init() {
        retrieveCities()
    }
    
    // 디스크에 저장되어 있는 cities json 파일을 읽어와서 cities에 담는다.
    func retrieveCities() {
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
    func updateCheck(within n: Int = 30) {
        let sec = Double(n) * 60
        for city in getCities() {
            let timeInterval = Date().timeIntervalSince1970 - city.updatedDate.timeIntervalSince1970
            if timeInterval >= sec {
                updateWeather(of: city)
            }
        }
    }
    
    // 도시의 기상 정보를 업데이트 시킨다.
    func updateWeather(of city: City) {
        WeatherAPI.getWeatherInfo(cityName: city.name,
                                  latitude: city.latitude, longitude: city.longitude)
        { city in
            self.store(city)
            guard let idx = self.cities.firstIndex(of: city) else { return }
            self.cities[idx] = city
            let notificationName = NSNotification.Name("weatherInfoArrived")
            NotificationCenter.default.post(name: notificationName,
                                            object: nil)
        }
    }
    
    // 입력된 도시를 json 형태로 저장
    private func store(_ city: City) {
        Storage.store(city, as: city.name)
    }
    
}
