import UIKit

enum Weekday: Int {
    case Sunday = 1
    case Monday = 2
    case Tuseday = 3
    case Wednesday = 4
    case Thursday = 5
    case Friday = 6
    case Saturday = 7
    case None = 8
    
    init?(rawValue: Int) {
        switch rawValue {
        case 1:
            self = .Sunday
        case 2:
            self = .Monday
        case 3:
            self = .Tuseday
        case 4:
            self = .Wednesday
        case 5:
            self = .Thursday
        case 6:
            self = .Friday
        case 7:
            self = .Saturday
        default:
            self = .None
        }
    }
    
    var week: String {
        switch self {
        case .Sunday : return "Sun"
        case .Monday : return "Mon"
        case .Tuseday : return "Tue"
        case .Wednesday : return "Wed"
        case .Thursday : return "Thu"
        case .Friday : return "Fri"
        case .Saturday : return "Sat"
        default:
            return "None"
        }
    }
}

extension UILabel {
    /**
     Highlight text in a label.
     */
    func setTextHighlighted(range: NSRange) {
        guard let text = self.text else { return }

        let attributedText = NSMutableAttributedString(string: text)
        let strokeTextAttribute: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]

        attributedText.addAttributes(strokeTextAttribute, range: range)
        self.attributedText = attributedText
    }
}

extension Date {
    
    // 입력된 timeZone에 해당하는 현재 시간을 HH:mm PM/AM 형태로 반환한다.
    func currentTime(timeZone: TimeZone) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = timeZone
        var time = formatter.string(from: self)
        
        let hour = Int(time.prefix(2))!

        if hour < 12{
            time = time + " AM"
        } else if hour == 12 {
            time = time + " PM"
        } else if hour > 12 {
            time = String(hour - 12) + ":" + time.suffix(2) + " PM"
        }
        if time.first! == "0" { time.removeFirst() }
        
        return time
    }
    
    // 입력된 timeZone에 해당하는 현재 Date의 요일을 반환한다.
    func currentDayOfAWeek(in timeZone: TimeZone) -> String {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        let weekdayComponent = calendar.component(.weekday, from: self)
        let dayOfAWeek = Weekday(rawValue: weekdayComponent)!.week
        
        return dayOfAWeek
    }
    
    // 입력된 Date와 timezone에 해당하는 시간을 HH PM/AM 형태로 반환한다.
    static func getTheTime(of when: Date, with timeZone: TimeZone) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        formatter.timeZone = timeZone
        let hour = Int(formatter.string(from: when))!
        
        if hour == 0 {
            return "12 AM"
        } else if hour < 12{
            return String(hour) + " AM"
        } else if hour == 12 {
            return String(hour) + " PM"
        }
        return String(hour - 12) + " PM"
    }
    
}

extension Float {
    
    func roundedString() -> String {
        return String(Int(self))
    }

}
