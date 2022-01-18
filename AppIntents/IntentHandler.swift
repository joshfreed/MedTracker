import Intents
import Dip
import JFLib_Services
import Common
import DefaultBackEnd

class IntentHandler: INExtension {
    let services = AppIntentsServices()
    let backEndModule = BackEndModule()
    let widgetCenterModule = WidgetCenterModule()

    override init() {
        super.init()
        services.logger.debug("IntentHandler::init")

        // Register Services
        let container = DipContainer()
        backEndModule.registerServices(env: .live, container: container.container)
        widgetCenterModule.registerServices(env: .live, container: container.container)
        container.container.register(.unique) { AppIntentsFacade(backEnd: $0) }.implements(AppIntentsApplication.self)
        JFServices.initialize(container: container)

        // Bootstrap App
        services.coreDataSavePublisher.publishWhenCoreDataSaves()
        backEndModule.bootstrap(env: .live)
        widgetCenterModule.bootstrap(env: .live)
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
