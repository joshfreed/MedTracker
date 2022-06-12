import Intents
import Dip
import JFLib_Services
import MTCommon
import MTDefaultBackEnd
import MTWidgetCenter
import MTLocalNotifications

class IntentHandler: INExtension {
    private let services = AppIntentsServices()
    private let modules: [MedTrackerModule] = [
        BackEndModule(),
        WidgetCenterModule(),
    ]

    override init() {
        super.init()
        services.logger.debug("IntentHandler::init")

        // Register Services
        let container = DipContainer()
        modules.forEach { $0.registerServices(env: .live, container: container.container) }
        LocalNotificationModule().registerServices(env: .live, container: container.container)
        container.container.register(.unique) { AppIntentsFacade(backEnd: $0) }.implements(AppIntentsApplication.self)
        JFServices.initialize(container: container)

        // Bootstrap App
        services.coreDataSavePublisher.publishWhenCoreDataSaves()
        modules.forEach { $0.bootstrap(env: .live) }
    }

    deinit {
        services.logger.debug("IntentHandler::deinit")
        services.coreDataSavePublisher.stopPublishing()
    }

    override func handler(for intent: INIntent) -> Any? {
        if intent is LogMedicationIntent {
            return LogMedicationIntentHandler(application: (try! JFServices.resolve() as AppIntentsApplication))
        }

        return nil
    }
}
