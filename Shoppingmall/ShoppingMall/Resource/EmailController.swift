import MessageUI

final class EmailController: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = EmailController()
    
    private override init() { }
    
    func sendEmail(subject: String, body: String, to: String) {
        if !MFMailComposeViewController.canSendMail() {
            AlertHelper.showAlert(withMessage: "Это устройство не может отправлять сообщения.")
            return
        }
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients([to])
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(body, isHTML: false)
        EmailController.getRootViewController()?.present(mailComposer, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        EmailController.getRootViewController()?.dismiss(animated: true, completion: nil)
    }
    
    static func getRootViewController() -> UIViewController? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if windowScene.delegate is UIWindowSceneDelegate {
                return windowScene.windows.first?.rootViewController
            }
        }
        return nil
    }
}
