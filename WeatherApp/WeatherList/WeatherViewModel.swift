// 가지고 있어야 하는 정보 : 저장된 도시에 대한 날씨 정보

import Foundation

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
                 longitude: String, completion: () -> Void) {
        WeatherAPI.getWeatherInfo(cityName: cityName,
                                  latitude: latitude,
                                  longitude: longitude) { city in
            store(city)
            cities.append(city)
            completion()
        }
    }
    
    func removeCity(_ city: City) {
        Storage.remove(city.name)
        
        if let idx = cities.firstIndex(of: city) {
            cities.remove(at: idx)
        }
    }
    
    // 유지하고 있는 도시목록 중에 유효시간(10분)이 지나서 업데이트해야 하는 도시가 있는지 검사
    func updateCheck() {
        
    }
    
    // 도시의 기상 정보를 업데이트 시킨다.
    func updateWeather(of city: City) {
        WeatherAPI.getWeatherInfo(cityName: city.name,
                                  latitude: city.latitude, longitude: city.longitude) {
            city in
            store(city)
            guard let idx = cities.firstIndex(of: city) else { return }
            cities[idx] = city
        }
    }
    
    // 입력된 도시를 json 형태로 저장
    private func store(_ city: City) {
        Storage.store(city, as: city.name)
    }
    
}
