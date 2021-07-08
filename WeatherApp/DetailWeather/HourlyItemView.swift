// hourlyWeatherView에서 각각의 시간에 해당하는 날씨 정보를 보여주는 뷰

import UIKit

class HourlyItemView: UIStackView {

    let timeLabel = UILabel()
    let weatherImageView = UIImageView()
    let temperatureLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .vertical
        self.alignment = .center
        self.distribution = .equalSpacing
        self.spacing = 10
        
        self.addArrangedSubview(timeLabel)
        self.addArrangedSubview(weatherImageView)
        self.addArrangedSubview(temperatureLabel)
        setupViews()
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        timeLabel.font = UIFont.boldSystemFont(ofSize: 30)
        timeLabel.textColor = .white
        weatherImageView.contentMode = .scaleAspectFit
        temperatureLabel.font = UIFont.boldSystemFont(ofSize: 30)
        temperatureLabel.textColor = .white
    }
    
    private func setupConstraints() {
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        weatherImageView.widthAnchor.constraint(equalTo: weatherImageView.heightAnchor).isActive = true
        
        timeLabel.setContentHuggingPriority(.init(248), for: .vertical)
        temperatureLabel.setContentHuggingPriority(.init(248), for: .vertical)
    }

}




   
    

