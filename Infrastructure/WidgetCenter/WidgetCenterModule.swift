import Foundation
import Dip
import Combine
import JFLib_Services
import MTCommon
import MTBackEndCore

class WidgetCenterModule: MedTrackerModule {
    private var cancellables = Set<AnyCancellable>()

    func registerServices(env: XcodeEnvironment, container: DependencyContainer) {
        switch env {
        case .live:
            container.register { MedTrackerWidgetCenter() }.implements(WidgetService.self)
        case .test:
            container.register { EmptyWidgetService() }.implements(WidgetService.self)
        case .preview:
            container.register { EmptyWidgetService() }.implements(WidgetService.self)
        }
    }

    func bootstrap(env: XcodeEnvironment) {
        let domainEvents: MedTrackerBackEndEvents = try! JFServices.resolve()

        Publishers.MergeMany(
            domainEvents.newMedicationTracked.map { _ in }.eraseToAnyPublisher(),
            domainEvents.administrationRecorded.map { _ in }.eraseToAnyPublisher(),
            domainEvents.administrationRemoved.map { _ in }.eraseToAnyPublisher()
        )
            .sink {
                let widgetService: WidgetService = try! JFServices.resolve()
                widgetService.reloadWidget()
            }
            .store(in: &cancellables)
    }
}
