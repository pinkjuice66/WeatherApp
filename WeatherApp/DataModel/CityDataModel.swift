import Foundation

struct City {
    let name: String
    let latitude: String
    let longitude: String
    let createdDate: Date
 
    var currentWeather: String
    var houlyWeather: String
    var dailyWeather: String
}


// current, houly, daily
// daily weather에는 temp가 그날짜 시간단위별로 나와있음
struct Weather {
    var current: String
    
}
