//
//  SharedData.swift
//  SeeingEye
//
//  Created by Aadi Shiv Malhotra on 8/8/23.
//

import Foundation
import SwiftUI

class ObservationModel: ObservableObject {
    @Published var observationConfidence: Float = 0.0
}
