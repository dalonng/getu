//
//  Item.swift
//  Getu-iOS
//
//  Created by 大桥 on 2024/8/5.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
