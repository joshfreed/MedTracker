import Foundation
import JFLib_Services
import JFLib_Mediator
import MedicationApp

class DailyScheduleViewModel: ObservableObject {
    @Published private(set) var date: String = ""
    @Published var medications: [DailySchedule.Medication] = []

    @Injected private var getTrackedMedications: GetTrackedMedicationsUseCase

    init() {}

    init(getDailySchedule: GetTrackedMedicationsUseCase) {
        self.getTrackedMedications = getDailySchedule
    }

    deinit {
        print("deinit")
    }

    func load() async {
        do {
            let response = try await getTrackedMedications.handle(GetTrackedMedicationsQuery(date: Date()))
            present(response)
        } catch {
            fatalError("\(error)")
        }
    }

    func updateAdministration(medicationId: String, wasAdministered: Bool) {
        print("updateAdministration \(medicationId), \(wasAdministered)")
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
        class UseCase: GetTrackedMedicationsUseCase {
            func handle(_ query: GetTrackedMedicationsQuery) async throws -> GetTrackedMedicationsResponse {
                let medications: [GetTrackedMedicationsResponse.Medication] = [
                    .init(id: "A", name: "Lexapro", wasAdministered: false),
                    .init(id: "B", name: "Allegra", wasAdministered: false),
                ]
                return .init(medications: medications)
            }
        }

        return DailyScheduleViewModel(getDailySchedule: UseCase())
    }
}
