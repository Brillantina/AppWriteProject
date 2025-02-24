//
//  Note.swift
//  appwriteProject
//
//  Created by Rita Marrano on 11/02/25.
//

import Foundation
import JSONCodable

struct Note: Codable, Identifiable {
    let id: String
    let text: String
}
