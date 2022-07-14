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

    init() {
        self.people = []
    }

    func add(_ prospect: Prospect) {
        people.append(prospect)
    }

    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
    }
}
