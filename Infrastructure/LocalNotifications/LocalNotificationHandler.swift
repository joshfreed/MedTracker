import UIKit

class LocalNotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    func register() {
        UNUserNotificationCenter.current().delegate = self
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo

        let medicationId = userInfo["medicationId"] as? String

        switch response.actionIdentifier {
        case "TAKE_ACTION": break
        case "SNOOZE_ACTION": break
        case "YES_ACTION": break
        case "NO_ACTION": break
        default: break
        }
    }
}
