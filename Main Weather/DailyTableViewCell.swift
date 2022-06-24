//
//  DailyTableViewCell.swift
//  Main Weather
//
//  Created by Shemets on 23.05.22.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    var nextWeekDaysLabel = UILabel()
    var nextWeekIconsImageView = UIImageView()
    var nextWeekTempMinMaxLabel = UILabel()
    var nextWeekWindSpeedLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        nextWeekDaysLabel = UILabel()
        nextWeekIconsImageView = UIImageView()
        nextWeekTempMinMaxLabel = UILabel()
        nextWeekWindSpeedLabel = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with object: Daily) {
        let date = Date(timeIntervalSince1970: Double(object.dt))
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEEE:"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale.current
        formatter.timeZone = .current
        let localDate = formatter.string(from: date)
        nextWeekDaysLabel.text = localDate
        
        nextWeekIconsImageView.image = UIImage(named: object.weather[0].icon)
        nextWeekTempMinMaxLabel.text = "min: \(String(Int(object.temp.min)))°,  max: \(String(Int(object.temp.max)))°"
        nextWeekWindSpeedLabel.text = "Wind: \(String(Int(object.windSpeed)))m/s"
    }
    
    private func setupUI() {
        let daysLabelWidth: CGFloat = contentView.bounds.width / 8
        let daysLabelHeight: CGFloat = contentView.bounds.height
        nextWeekDaysLabel.frame = CGRect(x: contentView.bounds.midX - daysLabelWidth * 3.8,
                                         y: contentView.bounds.midY - daysLabelHeight / 2,
                                         width: daysLabelWidth,
                                         height: daysLabelHeight)
        nextWeekDaysLabel.backgroundColor = .clear
        contentView.addSubview(nextWeekDaysLabel)
        
        let iconWidth: CGFloat = contentView.bounds.width / 8
        let iconHeight: CGFloat = contentView.bounds.height
        nextWeekIconsImageView.frame = nextWeekDaysLabel.frame.offsetBy(dx: daysLabelWidth * 1.1, dy: 0)
        nextWeekIconsImageView.frame.size = CGSize(width: iconWidth, height: iconHeight)
        nextWeekIconsImageView.backgroundColor = .clear
        contentView.addSubview(nextWeekIconsImageView)
        
        let tempWidth: CGFloat = contentView.bounds.width / 2
        let tempHeight: CGFloat = contentView.bounds.height
        nextWeekTempMinMaxLabel.frame = nextWeekIconsImageView.frame.offsetBy(dx:  iconWidth, dy: 0)
        nextWeekTempMinMaxLabel.frame.size = CGSize(width: tempWidth, height: tempHeight)
        nextWeekTempMinMaxLabel.backgroundColor = .clear
        nextWeekTempMinMaxLabel.font = .systemFont(ofSize: 19)
        nextWeekTempMinMaxLabel.textAlignment = .center
        contentView.addSubview(nextWeekTempMinMaxLabel)
        
        let windWidth: CGFloat = contentView.bounds.width / 2.6
        let windHight: CGFloat = contentView.bounds.height
        nextWeekWindSpeedLabel.frame = nextWeekTempMinMaxLabel.frame.offsetBy(dx: tempWidth / 1.2, dy: 0)
        nextWeekWindSpeedLabel.frame.size = CGSize(width: windWidth, height: windHight)
        nextWeekWindSpeedLabel.backgroundColor = .clear
        nextWeekWindSpeedLabel.textAlignment = .right
        nextWeekWindSpeedLabel.font = .systemFont(ofSize: 15)
        contentView.addSubview(nextWeekWindSpeedLabel)
    }
    
    
}
