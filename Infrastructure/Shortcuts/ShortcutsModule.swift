import Foundation
import Combine
import Dip
import JFLib_Services
import MTCommon
import MTBackEndCore

class ShortcutsModule: MedTrackerModule {
    private var cancellables = Set<AnyCancellable>()

    func registerServices(env: XcodeEnvironment, container: DependencyContainer) {
        switch env {
        case .live:
            container.register { IntentDonationService() }.implements(ShortcutDonationService.self)
        case .test:
            container.register { EmptyDonationService() }.implements(ShortcutDonationService.self)
        case .preview:
            container.register { EmptyDonationService() }.implements(ShortcutDonationService.self)
        }
    }

    func bootstrap(env: XcodeEnvironment) {
        let domainEvents: MedTrackerBackEndEvents = try! JFServices.resolve()

        domainEvents
            .administrationRecorded
            .sink { event in
                let donationService: ShortcutDonationService = try! JFServices.resolve()
                donationService.donateInteraction(domainEvent: event)
            }
            .store(in: &cancellables)
    }
}
