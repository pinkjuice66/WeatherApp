import UIKit

extension UILabel {
    /**
     Highlight text in a label.
     */
    
    func setTextHighlighted(range: NSRange) {
        guard let text = self.text else { return }

        let attributedText = NSMutableAttributedString(string: text)
        let strokeTextAttribute: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.blue
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
        
        return formatter.string(from: self)
    }
    
}
