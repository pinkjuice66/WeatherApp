import Foundation


class WeatherAPI {
    
    private static let baseURL = "https://api.openweathermap.org/data/2.5/onecall?"
    private static let appKey = "8d4a9866965708de8ba49ef6d2351e85"
    
    // 파라미터로 입력된 도시에 대한 날씨 정보를 받아온다.
    static func getWeatherInfo(cityName: String, latitude: String,
                               longitude: String, completion: (City) -> Void ) {
        var urlComponents = URLComponents(string: baseURL)
        let latitudeQuery = URLQueryItem(name: "lat", value: latitude)
        let longitudeQuery = URLQueryItem(name: "lon", value: longitude)
        let excludeQuery = URLQueryItem(name: "exclude", value: "minutely,alerts")
        let appKeyQuery = URLQueryItem(name: "appid", value: appKey)
        let unitQuery = URLQueryItem(name: "units", value: "metric")
        
        urlComponents?.queryItems?.append(contentsOf: [latitudeQuery, longitudeQuery, excludeQuery, appKeyQuery, unitQuery])
        let url = urlComponents?.url
        
        do {
            let jsonData = try Data(contentsOf: url!)
            
            do {
                let decoder = JSONDecoder()
                var service = try decoder.decode(WeatherService.self, from: jsonData)
                service.name = cityName
                let city = City(service)
                completion(city)
            } catch let error {
                print(error.localizedDescription)
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
