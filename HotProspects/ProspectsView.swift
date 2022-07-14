//
//  ProspectsView.swift
//  HotProspects
//
//  Created by QBUser on 14/07/22.
//

import SwiftUI

struct ProspectsView: View {

    enum FilterType {
        case none, contacted, uncontacted
    }

    let filter: FilterType

    @EnvironmentObject var prospects: Prospects

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(prospects.people) { prospect in
                        VStack (alignment: .leading) {
                            Text(prospect.name)
                            Text(prospect.emailAddress)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem {
                    Button {
                    #if Development
                        let prospect = Prospect()
                        prospect.name = "Azam"
                        prospect.emailAddress = "email@email.com"
                        self.prospects.people.append(prospect)
                    #endif
                    } label: {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
                }
            }
        }
    }

    var title: String {
        switch filter {
            case .none:
                return "Everyone"
            case .contacted:
                return "Contacted Person"
            case .uncontacted:
                return "Unontacted Person"
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
