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
    
    private init() {
        name = ""
        latitude = ""
        longitude = ""
        createdDate = Date()
        updatedDate = Date()
        timeZone = nil
        currentWeather = nil
        hourlyWeather = nil
        dailyWeather = nil
    }
    
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
                                    todaysMinTemperature: weatherService.daily.first?.temp.min,
                                    todaysMaxTemperature: weatherService.daily.first?.temp.max,
                                    sunrise: Date(timeIntervalSince1970: Double(weather.sunrise!)),
                                    sunset: Date(timeIntervalSince1970: Double(weather.sunset!)),
                                    humidity: weather.humidity,
                                    windSpeed: weather.wind_speed,
                                    feelsLike: weather.feels_like,
                                    pressure: weather.pressure,
                                    visibility: weather.visibility,
                                    uvIndex: weather.uvi,
                                    chanceOfRain: weatherService.daily.first!.pop
                                    )
        currentWeather = current
        
        var hourly = [DetailWeather]()
        for weather in weatherService.hourly {
            guard hourly.count <= 26 else { break }
            let detail = DetailWeather(temperature: weather.temp,
                                       time: Date(timeIntervalSince1970: Double(weather.dt)),
                                       weather: weather.weather.first!,
                                       chanceOfRain: weather.pop)
            hourly.append(detail)
        }
        hourly.removeFirst()
        hourlyWeather = hourly
        
        var daily = [DetailWeather]()
        for weather in weatherService.daily {
            let detail = DetailWeather(time: Date(timeIntervalSince1970:Double(weather.dt)),
                                       weather: weather.weather.first!,
                                       todaysMinTemperature: weather.temp.min,
                                       todaysMaxTemperature: weather.temp.max, chanceOfRain: weather.pop)
            daily.append(detail)
        }
        daily.removeFirst()
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
    
    static func empty() -> City {
        return City()
    }
}

// ?????? ??????. ????????? ??????, ???????????? ????????? ??????
struct Weather: Codable {
    let main: String
    let description: String
    let iconName: String
    
    enum CodingKeys: String, CodingKey {
        case main
        case description
        case iconName = "icon"
    }
}

// ?????? ????????? ?????? ?????? ????????? ?????? ?????? ????????? ????????? ?????? ??????
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



// API??? ?????? ?????? json????????? decoding ?????? ?????? ??????, ????????? DetailWeather ????????? ???????????????.
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
