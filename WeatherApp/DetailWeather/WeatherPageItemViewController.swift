// 해당 뷰컨트롤러는 pageViewController의 content 뷰컨트롤러로 동작하며, 현재, 시간별, 날짜별 날씨에 대한 정보를 표시한다.
// 뷰 구성 - backgroundScrollView가 전체를 감싸며, 그 안에 cityNameView, currentTemperatureView, hourlyWeatherView, dailyWeatherView, detailView가 구성되어져 있다. cityNameView와 currentTemperatureView의 경우 IB로 레이블을 직접 넣어서 구현하고, 나머지는 틀이되는 뷰만 만들고 programmatically하게 구현. 그림은 reamde 파일 참조


import UIKit

class WeatherPageItemViewController: UIViewController {
    
    // 전체 뷰를 구성하는 뷰들
    @IBOutlet weak var cityNameView: UIView!
    @IBOutlet weak var hourlyWeatherView: UIStackView!
    @IBOutlet weak var dailyWeatherView: UIStackView!
    @IBOutlet weak var detailWeatherInfoView: UIStackView!
    @IBOutlet weak var backgroundScrollView: UIScrollView!

        
    // cityNameView와 currentTemperatureView의 정보를 표시하기 위한 레이블들
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentWeatherDescriptionLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var todayDayLabel: UILabel!
    @IBOutlet weak var maxAndMinTemperatureLabel: UILabel!

    // currentTemperatureView 가 접히는 애니메이션 효과를 구현하기 위한 제약조건들
    @IBOutlet weak var currentTemperatureViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var hourlyWeatherViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dailyWeatherViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cityNameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cityNameViewHeightConstraint: NSLayoutConstraint!
    
    var indexOfCurrentPage: Int?
    private var cityWeatherInfo: City!
    private var currentTemperatureViewHeight: CGFloat!
    
    deinit {
//         설정된 updateNotification을 제거한다.
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDailyWeatherViewTopConstraintConstant()
        cityWeatherInfo = WeatherViewModel.shared.getCities()[indexOfCurrentPage!]
        
        backgroundScrollView.sendSubviewToBack(dailyWeatherView)
        backgroundScrollView.sendSubviewToBack(detailWeatherInfoView)
        
        // 각 뷰들을 구성하고 업데이트 시킨다.
        configureHourlyWeatehrView()
        configureDailyWeatherView()
        configureDetailWeatherInfoView()
        updateUI()
        
        // 날씨 정보가 업데이트 되었을 때 뷰의 데이터를 업데이트된 내용들로 수정한다.
        let notificationName = NSNotification.Name("weatherInfoUpdated")
        NotificationCenter.default.addObserver(self, selector:
                                                #selector(updateUI),
                                               name: notificationName,
                                               object: nil)
    }
    
}
    
extension WeatherPageItemViewController {
    
    // cityName view, currentTemperatureView, hourlyWeatherView의 높이를 합친 값만큼
    // dailyWeatherView의 top이 scroll view의 content로부터 떨어지도록 설정한다.
    private func setDailyWeatherViewTopConstraintConstant() {
        currentTemperatureViewHeight = currentTemperatureViewHeightConstraint.constant
        dailyWeatherViewTopConstraint.constant = cityNameViewHeightConstraint.constant +  currentTemperatureViewHeight + hourlyWeatherViewHeightConstraint.constant
    }
    
    // cityNameView에 있는 label들을 업데이트 시킨다.
    private func updateCityNameViewUI() {
        cityNameLabel.text = cityWeatherInfo.name
        currentWeatherDescriptionLabel.text = cityWeatherInfo.currentWeather?.weather?.description
        currentTemperatureLabel.text = (cityWeatherInfo.currentWeather?.temperature?.roundedString())! + "℃"
        
        // 도시의 현재 날짜의 요일을 가져온다.
        todayDayLabel.text = cityWeatherInfo.updatedDate.currentDayOfAWeek(in: cityWeatherInfo.timeZone!) + " Today"
        // Date.currentDay(in timeZone: Timezone) -> day of a week
        let todaysMaxtemperature = cityWeatherInfo.currentWeather?.todaysMaxTemperature?.roundedString() ?? ""
        let todaysMintemperature = cityWeatherInfo.currentWeather?.todaysMinTemperature?.roundedString() ?? ""
        maxAndMinTemperatureLabel.text = "\(todaysMaxtemperature)    \(todaysMintemperature)"
    }
    
    // hourlyWeatherView를 구성
    private func configureHourlyWeatehrView() {
        // hourlyWeatherView에서 현재를 나타내는 뷰
        let hourlyItemView = HourlyItemView()
        hourlyItemView.timeLabel.text = "Now"
        hourlyItemView.temperatureLabel.text = String((cityWeatherInfo.currentWeather?.temperature?.rounded())!)
        hourlyWeatherView.addArrangedSubview(hourlyItemView)
        if let iconImage = UIImage(named:
                                    cityWeatherInfo.currentWeather?.weather!.iconName ?? "10d") {
            hourlyItemView.weatherImageView.image = iconImage
        }
        
        // hourlyWeather에 있는 요소의 개수만큼 hourlyItemView를 추가한다.
        for _ in 1...cityWeatherInfo.hourlyWeather!.count {
            let hourlyItemView = HourlyItemView()
            hourlyWeatherView.addArrangedSubview(hourlyItemView)
        }
    }
    
    // hourlyWeatherView에 있는 hourlyItemView들의 온도, 시간, 날씨를 업데이트 한다.
    private func updateHourlyWeatherView() {
        for i in 1...cityWeatherInfo.hourlyWeather!.count {
            guard let hourlyItemView = hourlyWeatherView.subviews[i]
                    as? HourlyItemView else { return }
            
            let hourlyWeatherInfo = cityWeatherInfo.hourlyWeather![i - 1]
            let time = Date.getTheTime(of: hourlyWeatherInfo.time! ,
                                       with: cityWeatherInfo.timeZone!)
            let image = UIImage(named: hourlyWeatherInfo.weather!.iconName)
            hourlyItemView.timeLabel.text = time
            hourlyItemView.temperatureLabel.text = String((hourlyWeatherInfo.temperature?.roundedString())!)
            hourlyItemView.weatherImageView.image = image
        }
    }
    
    // dailyWeatherView를 구성
    private func configureDailyWeatherView() {
        // dailyWeather에 있는 요소의 개수만큼 dailyItemView를 추가한다.
        for _ in 1...cityWeatherInfo.dailyWeather!.count {
            let dailyItemView = DailyItemView()
            dailyWeatherView.addArrangedSubview(dailyItemView)
        }
    }
    
    // dailyWeatherView에 있는 dailyItemView들의 온도, 시간, 날씨를 업데이트 한다.
    private func updateDailyWeatherViewUI() {
        for i in 0..<cityWeatherInfo.dailyWeather!.count {
            guard let dailyItemView = dailyWeatherView.subviews[i]
                    as? DailyItemView else { return }
            let dailyWeatherInfo = cityWeatherInfo.dailyWeather![i]
            dailyItemView.dayLabel.text = dailyWeatherInfo.time?.currentDayOfAWeek(in: cityWeatherInfo.timeZone!)
            dailyItemView.weatherImageView.image = UIImage(named: dailyWeatherInfo.weather!.iconName) ?? UIImage()
            dailyItemView.maxTemperatureLabel.text = dailyWeatherInfo.todaysMaxTemperature?.roundedString()
            dailyItemView.minTemperatureLabel.text =
                dailyWeatherInfo.todaysMinTemperature?.roundedString()
        }
    }
    
    private func configureDetailWeatherInfoView() {
        let labelText = ["SUNRISE", "SUNSET", "CHANCE OF RAIN", "HUMIDITY",
                         "WIND", "FEELS LIKE", "PRESSURE", "VISIBILITY", "UV INDEX"]
        for i in 0...8 {
            let detailItemView = DetailItemView()
            detailItemView.sectionLabel.text = labelText[i]
            detailWeatherInfoView.addArrangedSubview(detailItemView)
        }
    }
    
    private func updateDetailWeatherInfoViewUI() {
        let info = cityWeatherInfo.currentWeather
        var detailWeatherInfo = [String]()
        detailWeatherInfo.append(info?.sunrise?.currentTime(timeZone: cityWeatherInfo.timeZone!) ?? "")
        detailWeatherInfo.append(info?.sunset?.currentTime(timeZone: cityWeatherInfo.timeZone!) ?? "")
        detailWeatherInfo.append(String(Int((info?.chanceOfRain)! * 100)) + "%")
        detailWeatherInfo.append(String((info?.humidity)!) + "%")
        detailWeatherInfo.append(String((info?.windSpeed)!) + " m/s" )
        detailWeatherInfo.append((info?.feelsLike?.roundedString())! + "℃")
        detailWeatherInfo.append(String((info?.pressure)!) + "hPA")
        detailWeatherInfo.append(String((info?.visibility)! / 1000) + "km")
        detailWeatherInfo.append((info?.uvIndex?.roundedString())!)
        
        for i in 0...8 {
            guard let detailItemView = detailWeatherInfoView.subviews[i] as? DetailItemView else { return }
            detailItemView.descriptionLabel.text = detailWeatherInfo[i]
        }
    }
    
    // 각 view들에 있는 레이블 및 이미지를 cityWeatherInfo를 바탕으로 업데이트 시킨다.
    @objc private func updateUI() {
        updateCityNameViewUI()
        updateHourlyWeatherView()
        updateDailyWeatherViewUI()
        updateDetailWeatherInfoViewUI()
    }
    
}
    
extension WeatherPageItemViewController: UIScrollViewDelegate {
    
    // 스크롤이 내려가거나 올라갈 때, currentTemperatureView의 초기 높이인 currentTemperatureViewHeight보다 아래로 내려가면, currentTemperatureView의 높이를 점점 줄이고 currentTemperatureView보다 위로 올라가면, currentTemperatureView의 높이를 늘려서 보이도록 설정한다.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < currentTemperatureViewHeight {
            currentTemperatureViewHeightConstraint.constant =
                currentTemperatureViewHeight - scrollView.contentOffset.y
            
            let ratio = (currentTemperatureViewHeightConstraint.constant / currentTemperatureViewHeight)
            // cityNameView의 cityNameLabel이 currentTemperatureView의 높이가 올라가고 내려감에 따라 같이 올라가고 내려가도록 한다.
            // ratio가 1이하 일때만 동작하도록 한 것은 currentTemperatureView가 접혀있지 않은 상태에서 위로 더 스크롤하려는 경우, cityName의 top constraint가 15보다 커지는것을 방지
            if ratio <= 1{
                cityNameTopConstraint.constant = ratio * 15
            }
            
            // 현재 기온 및 요일, 최고 최저 온도 레이블 투명하게 설정 ---->
            let alpha = currentTemperatureViewHeightConstraint.constant / currentTemperatureViewHeight
            currentTemperatureLabel.alpha = alpha
            todayDayLabel.alpha = alpha
            maxAndMinTemperatureLabel.alpha = alpha
        } else if currentTemperatureViewHeight < scrollView.contentOffset.y {
            currentTemperatureViewHeightConstraint.constant = 0
            cityNameTopConstraint.constant = 0
            currentTemperatureLabel.alpha = 0
            todayDayLabel.alpha = 0
            maxAndMinTemperatureLabel.alpha = 0
        }
    }
    
}
