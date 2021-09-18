//
//  HapticManager.swift
//  CryptoTracker
//
//  Created by saw Tarmalar on 18/09/2021.
//

import Foundation
import SwiftUI

class HapticManager {
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType ){
        generator.notificationOccurred(type)
    }
    
}
