import Foundation
import CoreData
import MedicationApp

class CoreDataMedications: MedicationRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func add(_ medication: Medication) async throws {
        let entity = CDMedication(context: context)
        entity.populateFromDomain(medication)
    }

    func getAll() async throws -> [Medication] {
        let request = CDMedication.fetchRequest()
        let result = try context.fetch(request)
        return try result.map(Medication.fromCoreData)
    }

    func getById(_ id: MedicationId) async throws -> Medication? {
        let request = CDMedication.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %@", id.uuid as CVarArg)
        guard let entity = try context.fetch(request).first else {
            return nil
        }
        return try Medication.fromCoreData(entity)
    }

    func save() async throws {
        try context.save()
    }
}

// MARK: - Mapping

extension CDMedication {
    func populateFromDomain(_ medication: Medication) {
        id = medication.id.uuid
        name = medication.name
        administrationHour = Int16(medication.administrationTime)
    }
}

extension Medication {
    static func fromCoreData(_ entity: CDMedication) throws -> Medication {
        let values: [String: Any] = [
            "id": ["uuid": entity.id!.uuidString],
            "name": entity.name!,
            "administrationTime": Int(entity.administrationHour)
        ]
        let data = try JSONSerialization.data(withJSONObject: values, options: [])
        let decoder = JSONDecoder()
        return try decoder.decode(Medication.self, from: data)
    }
}
