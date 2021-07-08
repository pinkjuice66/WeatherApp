// dailyWeatherView에서 각각의 날짜에 해당하는 날씨 정보를 보여주는 뷰

import UIKit

class DailyItemView: UIStackView {

    let dayLabel = UILabel()
    let weatherImageView = UIImageView()
    let maxTemperatureLabel = UILabel()
    let minTemperatureLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .equalSpacing
        
        self.addArrangedSubview(dayLabel)
        self.addArrangedSubview(weatherImageView)
        self.addArrangedSubview(maxTemperatureLabel)
        self.addArrangedSubview(minTemperatureLabel)
        setupViews()
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        dayLabel.font = UIFont.boldSystemFont(ofSize: 30)
        dayLabel.textColor = .white
        weatherImageView.contentMode = .scaleAspectFit
        maxTemperatureLabel.font = UIFont.boldSystemFont(ofSize: 30)
        maxTemperatureLabel.textColor = .white
        maxTemperatureLabel.textAlignment = .center
        minTemperatureLabel.font = UIFont.boldSystemFont(ofSize: 30)
        minTemperatureLabel.textColor = .white
        minTemperatureLabel.textAlignment = .center
    }
    
    private func setupConstraints() {
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.35).isActive = true
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1).isActive = true
        maxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTemperatureLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.15).isActive = true
        minTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        minTemperatureLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.15).isActive = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalTo: maxTemperatureLabel.widthAnchor, constant: -10).isActive = true
    }

}
