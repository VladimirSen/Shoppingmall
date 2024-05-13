import SwiftUI

final class AlertHelper {
    static func showAlert(withMessage message: String) {
        UIViewController.getTopViewController { topViewController in
            if let controller = topViewController {
                let alertController = UIAlertController(title: "Ошибка",
                                                        message: message,
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                controller.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
