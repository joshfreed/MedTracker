//
//  DailyScheduleViewModel.swift
//  MedTracker
//
//  Created by Josh Freed on 11/30/21.
//

import Foundation

class DailyScheduleViewModel: ObservableObject {
    @Published private(set) var date: String = ""
    @Published private(set) var medications: [Medication] = []

    func load() {
        date = "Nov 30th, 2021"

        medications = [
            .init(
                name: "Lexapro",
                frequency: "BID",
                administrations: [
                    .init(time: "9am Dose", wasAdministered: true),
                    .init(time: "5pm Dose", wasAdministered: false)
                ]
            ),
            .init(
                name: "Allegra",
                frequency: "Daily",
                administrations: [
                    .init(time: "9am Dose", wasAdministered: true),
                ]
            ),
        ]
    }
}

// MARK: - Model

struct Medication: Identifiable {
    var id: String { name }
    let name: String
    let frequency: String
    let administrations: [Administration]
}

struct Administration: Identifiable {
    var id: String { time }
    let time: String
    let wasAdministered: Bool
}

// MARK: - Fakes

extension DailyScheduleViewModel {
    static func fake() -> DailyScheduleViewModel {
        let vm = DailyScheduleViewModel()

        vm.date = "Nov 30th, 2021"

        vm.medications = [
            .init(
                name: "Lexapro",
                frequency: "BID",
                administrations: [
                    .init(time: "9am Dose", wasAdministered: true),
                    .init(time: "5pm Dose", wasAdministered: false)
                ]
            ),
            .init(
                name: "Allegra",
                frequency: "Daily",
                administrations: [
                    .init(time: "9am Dose", wasAdministered: true),
                ]
            ),
        ]

        return vm
    }
}
