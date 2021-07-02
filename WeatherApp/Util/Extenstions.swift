import UIKit

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
    
}
