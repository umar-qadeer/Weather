
import UIKit

typealias AlertActionHandler = () -> Void

final class AlertBuilder: NSObject {

    public static func showSuccessAlertWithMessage(message: String?, on viewController: UIViewController) {
        self.showAlertWithTitle(title: Strings.Alert.success, message: message, shoulShowCancelButton: false, on: viewController)
    }

    public static func showfailureAlertWithMessage(message: String?, on viewController: UIViewController) {
        self.showAlertWithTitle(title: Strings.Alert.error, message: message, shoulShowCancelButton: false, on: viewController)
    }

    public static func showAlertWithTitle(title: String?, message: String?, confirmButtonTitle: String = Strings.Alert.okay, confirmButtonHandler: AlertActionHandler? = nil, shoulShowCancelButton: Bool, cancelButtonHandler: AlertActionHandler? = nil, on viewController: UIViewController) {
        let alert = prepareAlert(title: title, message: message)
        addAction(alert: alert, title: confirmButtonTitle, style: .default, handler: confirmButtonHandler)

        if shoulShowCancelButton {
            addAction(alert: alert, title: Strings.Alert.cancel, style: .cancel, handler: cancelButtonHandler)
        }
        
        showAlert(alert: alert, on: viewController)
    }

    static func prepareAlert(title: String?, message: String?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return alertController
    }

    static func addAction(alert: UIAlertController, title: String?, style: UIAlertAction.Style, handler: AlertActionHandler? = nil) {
        alert.addAction(UIAlertAction(title: title, style: style, handler: { _ in
            handler?()
        }))
    }
    
    private static func showAlert(alert: UIAlertController, on viewController: UIViewController) {
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
