import UIKit

class SearchedCityCell: UITableViewCell {

    static let reuseIdentifier = "SearchedCityCell"
    
    let cityLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setUpUI() {
        contentView.addSubview(cityLabel)
        
        cityLabel.numberOfLines = 1
        cityLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        cityLabel.adjustsFontForContentSizeCategory = true
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.textColor = .gray

        cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        cityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
        cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
    }
    
}
