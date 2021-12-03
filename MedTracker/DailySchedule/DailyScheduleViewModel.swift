import Foundation
import Combine
import JFLib_Services
import JFLib_Mediator
import MedicationApp

class DailyScheduleViewModel: ObservableObject {
    @Published private(set) var date: String = ""
    @Published var medications: [DailySchedule.Medication] = []

    @Injected private var getTrackedMedications: GetTrackedMedicationsContinuousQuery
    @Injected private var recordAdministration: RecordAdministrationUseCase

    private var cancellable: AnyCancellable?

    init() {}

    init(getTrackedMedications: GetTrackedMedicationsContinuousQuery) {
        self.getTrackedMedications = getTrackedMedications
    }

    deinit {
        print("deinit")
    }

    func load() async {
        guard cancellable == nil else { return }

        cancellable = getTrackedMedications
            .subscribe(GetTrackedMedicationsQuery(date: Date()))
            .receive(on: RunLoop.main)
            .catch { error -> AnyPublisher<GetTrackedMedicationsResponse, Never> in
                print("\(error)")
                return Just(GetTrackedMedicationsResponse(medications: [])).eraseToAnyPublisher()
            }
            .sink { [weak self] response in
                self?.present(response)
            }
    }

    func updateAdministration(medicationId: String, wasAdministered: Bool) {
        Task {
            if wasAdministered {
                do {
                    try await recordAdministration.handle(RecordAdministrationCommand(medicationId: medicationId))
                } catch {
                    fatalError("\(error)")
                }
            }
        }
    }
}

// MARK: - Model

class DailySchedule {}

extension DailySchedule {

    struct Medication: Identifiable {
        let id: String
        let name: String

        var wasAdministered: Bool {
            didSet {
                wasAdministeredDidSet(id, wasAdministered)
            }
        }

        var wasAdministeredDidSet: (String, Bool) -> Void = { _, _ in }
    }

}

// MARK: - Presentation

extension DailyScheduleViewModel {
    func present(_ response: GetTrackedMedicationsResponse) {
        date = "Nov 30th, 2021"
        
        medications = response.medications.map {
            .init(id: $0.id, name: $0.name, wasAdministered: $0.wasAdministered)
        }

        for i in 0..<medications.count {
            medications[i].wasAdministeredDidSet = updateAdministration
        }
    }
}

// MARK: - Fakes / Previews

extension DailyScheduleViewModel {
    static func fake() -> DailyScheduleViewModel {
        class UseCase: GetTrackedMedicationsContinuousQuery {
            func subscribe(_ query: GetTrackedMedicationsQuery) -> AnyPublisher<GetTrackedMedicationsResponse, Error> {
                let medications: [GetTrackedMedicationsResponse.Medication] = [
                    .init(id: "A", name: "Lexapro", wasAdministered: false),
                    .init(id: "B", name: "Allegra", wasAdministered: false),
                ]
                return Just(.init(medications: medications)).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
        }

        return DailyScheduleViewModel(getTrackedMedications: UseCase())
    }
}
