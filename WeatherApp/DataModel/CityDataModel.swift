import Foundation

struct City: Codable, Equatable, Comparable {
    let name: String
    let latitude: String
    let longitude: String
    let createdDate: Date
    var updatedDate: Date
    let timeZone: TimeZone?
    
    var currentWeather: DetailWeather?
    var hourlyWeather: [DetailWeather]?
    var dailyWeather: [DetailWeather]?
    
    init(_ weatherService: WeatherService) {
        
        name = weatherService.name ?? ""
        latitude = String(weatherService.lat)
        longitude = String(weatherService.lon)
        createdDate = Date()
        updatedDate = Date()
        timeZone = TimeZone(secondsFromGMT: weatherService.timezone_offset)
                
        let weather = weatherService.current
        let current = DetailWeather(temperature: weather.temp,
                                    weather: weather.weather.first!,
                                    sunrise: Date(timeIntervalSince1970: Double(weather.sunrise!)),
                                    sunset: Date(timeIntervalSince1970: Double(weather.sunset!)),
                                    humidity: weather.humidity,
                                    windSpeed: weather.wind_speed,
                                    feelsLike: weather.feels_like,
                                    pressure: weather.pressure,
                                    visibility: weather.visibility,
                                    uvIndex: weather.uvi, chanceOfRain: nil)
        currentWeather = current
        
        var hourly = [DetailWeather]()
        for weather in weatherService.hourly {
            let detail = DetailWeather(temperature: weather.temp,
                                       time: Date(timeIntervalSince1970: Double(weather.dt)),
                                       weather: weather.weather.first!,
                                       chanceOfRain: weather.pop)
            hourly.append(detail)
        }
        hourlyWeather = hourly
        
        var daily = [DetailWeather]()
        for weather in weatherService.daily {
            let detail = DetailWeather(time: Date(timeIntervalSince1970:Double(weather.dt)),
                                       weather: weather.weather.first!,
                                       todaysMinTemperature: weather.temp.min, todaysMaxTemperature: weather.temp.max, chanceOfRain: weather.pop)
            daily.append(detail)
        }
        dailyWeather = daily
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        let result = lhs.createdDate.compare(rhs.createdDate)
        return result == .orderedAscending
    }
    
    static func > (lhs: Self, rhs: Self) -> Bool {
        let result = lhs.createdDate.compare(rhs.createdDate)
        return result == .orderedDescending
    }
}

// 날씨 정보. 날씨와 설명, 아이콘을 가지고 있음
struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}

// 특정 시간대 혹은 특정 날짜에 대한 날씨 정보를 가지고 있는 모델
struct DetailWeather: Codable {
    var temperature: Float?
    var time: Date?
    var weather: Weather?
    var todaysMinTemperature: Float?
    var todaysMaxTemperature: Float?
    var sunrise: Date?
    var sunset: Date?
    var humidity: Int?
    var windSpeed: Float?
    var feelsLike: Float?
    var pressure: Int?
    var visibility: Int? // meters
    var uvIndex: Float?
    var chanceOfRain: Float?
}



// API를 통해 오는 json파일을 decoding 하기 위한 모델, 추후에 DetailWeather 형태로 변환시킨다.
struct WeatherService: Codable {
    var name: String?
    let lat: Float
    let lon: Float
    let timezone_offset: Int
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
    
    struct Current: Codable {
        let dt: Int
        let sunrise: Int?
        let sunset: Int?
        let temp: Float
        let feels_like: Float
        let pressure: Int
        let humidity: Int
        let uvi: Float
        let visibility: Int
        let wind_speed: Float
        let weather: [Weather]
    }
    
    struct Hourly: Codable {
        let dt: Int
        let temp: Float
        let weather: [Weather]
        let pop: Float
    }
    
    struct Daily: Codable {
        let dt: Int
        let temp: Temp
        let weather: [Weather]
        let pop: Float
        
        struct Temp: Codable {
            let min: Float
            let max: Float
        }
    }
}
