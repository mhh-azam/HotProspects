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

    var body: some View {
        NavigationView {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .navigationTitle(title)
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
    }
}
