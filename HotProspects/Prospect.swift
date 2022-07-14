//
//  Prospect.swift
//  HotProspects
//
//  Created by QBUser on 14/07/22.
//

import Foundation

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]

    let url = FileManager.default.documentsDirectory.appendingPathComponent("SavedData")

    init() {
        do {
            let data = try Data(contentsOf: url)
            self.people = try JSONDecoder().decode([Prospect].self, from: data)
        } catch {
            self.people = []
        }
    }

    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }

    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(self.people)
            try data.write(to: url, options: [.atomic, .completeFileProtection])
        } catch {
            print("Failed to save data at \(url): \(error.localizedDescription).")
        }
    }
}
