//
//  User.swift
//  ti6
//
//  Created by Larissa Kaweski Siqueira on 16/03/23.
//

import Foundation
import UIKit

public struct UserEntity: Codable {
    let name: String
//    let photo: String
//    let colorPreferance: String
}

public struct DiagnosticViewEntity: Equatable {
    public let patientName: String
    public let patientAge: String
    public let patientSex: String
    public let patientDiagnostic: String
    public let patientImage: UIImage
}
