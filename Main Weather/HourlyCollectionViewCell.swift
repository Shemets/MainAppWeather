//
//  HourlyCollectionViewCell.swift
//  Main Weather
//
//  Created by Shemets on 23.05.22.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
 
    var timeLabel = UILabel()
    var iconHourlyImageView = UIImageView()
    var tempHourlyLabel = UILabel()
    
    override init(frame: CGRect) {
        timeLabel = UILabel()
        iconHourlyImageView = UIImageView()
        tempHourlyLabel = UILabel()
        
        super.init(frame: frame)
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(iconHourlyImageView)
        contentView.addSubview(tempHourlyLabel)
    }
      
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with object: Current) {
        let date = Date(timeIntervalSince1970: Double(object.dt))
        let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                formatter.calendar = Calendar(identifier: .iso8601)
                formatter.locale = Locale.current
                formatter.timeZone = .current
            let localDate = formatter.string(from: date)
            timeLabel.text = localDate

        iconHourlyImageView.image = UIImage(named: object.weather[0].icon)
        tempHourlyLabel.text = "\(String(Int(object.temp)))°"
    }
    
    override func layoutSubviews() {
        let cellObjectWidth: CGFloat = contentView.bounds.width - 20
        let cellObjectHeight: CGFloat = contentView.bounds.height / 3.5
        timeLabel.frame = CGRect(x: contentView.bounds.midX - cellObjectWidth / 2,
                                 y: contentView.bounds.minY + cellObjectHeight / 4,
                                       width: cellObjectWidth,
                                       height: cellObjectHeight)
        timeLabel.font = .systemFont(ofSize: 25)
        timeLabel.textAlignment = .center
        timeLabel.backgroundColor = .clear
        
        
        let iconHourlyWidth: CGFloat = contentView.bounds.width / 1.7
        let iconHourlyHeight: CGFloat = contentView.bounds.width / 1.7
        iconHourlyImageView.frame = timeLabel.frame.offsetBy(dx: iconHourlyWidth / 5, dy: cellObjectHeight / 2)
        iconHourlyImageView.frame.size = CGSize(width: iconHourlyWidth, height: iconHourlyHeight)
        iconHourlyImageView.contentMode = .scaleAspectFill
        iconHourlyImageView.backgroundColor = .clear
        
        tempHourlyLabel.frame = timeLabel.frame.offsetBy(dx: 0, dy: cellObjectHeight * 2)
        tempHourlyLabel.font = .systemFont(ofSize: 25)
//        tempHourlyLabel.text = "--"
        tempHourlyLabel.textAlignment = .center
        tempHourlyLabel.backgroundColor = .clear
    }
}
