// detailWeatherInfoView에서 sunrise, sunset 등의 날씨 세부 정보를 보여주는 뷰

import UIKit

class DetailItemView: UIView {
    
    let sectionLabel = UILabel()
    let descriptionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {        
        sectionLabel.font = UIFont.boldSystemFont(ofSize: 30)
        sectionLabel.alpha = 0.7
        sectionLabel.textColor = .white
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 50)
        descriptionLabel.textColor = .white
        
        self.addSubview(sectionLabel)
        self.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        sectionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 0).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        
        let separatorView = UIView()
        self.addSubview(separatorView)
        separatorView.backgroundColor = .white
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
}
