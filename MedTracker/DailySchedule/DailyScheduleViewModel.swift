import Foundation
import OSLog
import Combine
import JFLib_Services
import MedicationApp

class DailyScheduleViewModel: ObservableObject {
    @Published private(set) var date: String = ""
    @Published var medications: [DailySchedule.Medication] = []
    @Published var lastFetchedAt: String = ""

    @Injected private var backEnd: MedTrackerApplication

    private var cancellable: AnyCancellable?

    init() {
        Logger.dailySchedule.debug("init")
    }

    init(backEnd: MedTrackerApplication) {
        Logger.dailySchedule.debug("init")
        self.backEnd = backEnd
    }

    deinit {
        Logger.dailySchedule.debug("deinit")
    }

    func load() {
        Logger.dailySchedule.debug("load")
        
        guard cancellable == nil else { return }

        let date = Date()

        Logger.dailySchedule.debug("loading meds for \(date, privacy: .public)")

        cancellable = backEnd
            .getTrackedMedications(date: date)
            .receive(on: RunLoop.main)
            .print("GetTrackedMedicationsQuery", to: self)
            .logError(to: .dailySchedule, andReplaceWith: GetTrackedMedicationsResponse(date: date, medications: []))
            .sink { [weak self] response in
                self?.present(response)
            }
    }

    func cancel() {
        cancellable = nil
    }
}

// MARK: Record or Remove Administration

extension DailyScheduleViewModel {
    func updateAdministration(medicationId: String, wasAdministered: Bool) {
        Task {
            await updateAdministrationAsync(medicationId: medicationId, wasAdministered: wasAdministered)
        }
    }

    private func updateAdministrationAsync(medicationId: String, wasAdministered: Bool) async {
        if wasAdministered {
            await recordAdministration(medicationId: medicationId)
        } else {
            await removeAdministration(medicationId: medicationId)
        }
    }

    private func recordAdministration(medicationId: String) async {
        do {
            try await backEnd.recordAdministration(medicationId: medicationId)
        } catch RecordAdministrationError.administrationAlreadyRecorded {
            Logger.dailySchedule.warning("Tried to record an administration for a medication that was already logged today.")
        } catch {
            Logger.dailySchedule.error(error)
            fatalError("\(error)")
        }
    }

    private func removeAdministration(medicationId: String) async {
        do {
            try await backEnd.removeAdministration(medicationId: medicationId)
        } catch {
            Logger.dailySchedule.error(error)
            fatalError("\(error)")
        }
    }
}

// MARK: TextOutputStream

extension DailyScheduleViewModel: TextOutputStream {
    func write(_ string: String) {
        guard !string.isEmpty && string != "\n" else { return }
        Logger.dailySchedule.debug("\(string, privacy: .public)")
    }
}

// MARK: - Model

enum DailySchedule {}

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
        let df = DateFormatter()
        df.dateFormat = "MMMM d"
        date = df.string(from: response.date)

        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        lastFetchedAt = df.string(from: response.date)

        medications = response.medications.map {
            .init(id: $0.id, name: $0.name, wasAdministered: $0.wasAdministered)
        }

        for i in 0..<medications.count {
            medications[i].wasAdministeredDidSet = updateAdministration
        }
    }
}

// MARK: - Preview

extension DailyScheduleViewModel {
    static func preview() -> DailyScheduleViewModel {
        DailyScheduleViewModel(backEnd: .preview())
    }
}
