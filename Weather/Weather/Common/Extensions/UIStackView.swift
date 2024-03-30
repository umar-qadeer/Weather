
import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach(addArrangedSubview(_:))
    }
    
    func removeAllArrangedSubview() {
        self.arrangedSubviews.forEach { (view) in
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
