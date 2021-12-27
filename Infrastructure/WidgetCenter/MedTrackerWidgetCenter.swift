import Foundation
import MedicationApp
import WidgetKit

class MedTrackerWidgetCenter: WidgetService {
    func reloadWidget() {
        WidgetCenter.shared.reloadTimelines(ofKind: "com.medtracker.daily-summary")
    }
}
