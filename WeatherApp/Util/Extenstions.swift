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
//        NSRange

        attributedText.addAttributes(strokeTextAttribute, range: range)
        self.attributedText = attributedText
    }

}
