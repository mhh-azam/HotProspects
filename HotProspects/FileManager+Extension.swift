//
//  FileManager+Extension.swift
//  HotProspects
//
//  Created by QBUser on 14/07/22.
//

import Foundation

extension FileManager {
    var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
