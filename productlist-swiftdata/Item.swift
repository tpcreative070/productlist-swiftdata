//
//  Item.swift
//  productlist-swiftdata
//
//  Created by phong on 31/5/24.
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
