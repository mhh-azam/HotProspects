//
//  ProspectsView.swift
//  HotProspects
//
//  Created by QBUser on 14/07/22.
//

import CodeScanner
import SwiftUI
import UserNotifications

struct ProspectsView: View {

    enum FilterType {
        case none, contacted, uncontacted
    }

    let filter: FilterType

    @EnvironmentObject var prospects: Prospects
    @State private var isScannerPresented = false

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(filteredProspects) { prospect in
                        HStack {
                            VStack (alignment: .leading) {
                                Text(prospect.name)
                                    .font(.headline)
                                Text(prospect.emailAddress)
                                    .foregroundColor(.secondary)
                            }

                            if filter == .none {
                                Spacer()
                                Image(systemName: prospect.isContacted ? "person.fill.checkmark" : "person.fill.xmark" )
                            }
                        }
                        .swipeActions {
                            if prospect.isContacted {
                                Button {
                                    prospects.toggle(prospect)
                                } label: {
                                    Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                                }
                                .tint(.blue)
                            }
                            else {
                                Button {
                                    prospects.toggle(prospect)
                                } label: {
                                    Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                                }
                                .tint(.green)

                                Button {
                                    addNotification(for: prospect)
                                } label: {
                                    Label("Remind Me", systemImage: "bell")
                                }
                                .tint(.orange)
                            }
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem {
                    Button {
                        isScannerPresented = true
                    } label: {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
                }
            }
            .sheet(isPresented: $isScannerPresented) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Aazam Chhipa\nazam@azam.com", completion: handleScan(result:))
            }
        }
        .navigationViewStyle(.stack)
    }

    var filteredProspects: [Prospect] {
        switch filter {
            case .none:
                return prospects.people
            case .contacted:
                return prospects.people.filter { $0.isContacted }
            case .uncontacted:
                return prospects.people.filter { !$0.isContacted }
        }
    }

    var title: String {
        switch filter {
            case .none:
                return "Everyone"
            case .contacted:
                return "Contacted Person"
            case .uncontacted:
                return "Uncontacted Person"
        }
    }

    func handleScan(result: Result<ScanResult, ScanError>) {
        isScannerPresented = false

        switch result {
            case .success(let result):
                let details = result.string.components(separatedBy: "\n")
                guard details.count == 2 else { return }

                let prospect = Prospect()
                prospect.name = details[0]
                prospect.emailAddress = details[1]
                self.prospects.add(prospect)

            case .failure(let error):
                print("Scanning failed: \(error.localizedDescription)")
        }
    }

    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        let addrequest = {

            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = .default

            var dateComponent = DateComponents()
            dateComponent.hour = 9
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            center.add(request)
        }

        center.getNotificationSettings { setting in
            if setting.authorizationStatus == .authorized {
                addrequest()
            }
            else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addrequest()
                    }
                    else {
                        print("D'oh!")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
