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
    @Attribute(.unique) var name : String
    var date : Date
    var value : Double
    
    init(name: String, date: Date, value: Double) {
        self.name = name
        self.date = date
        self.value = value
    }
}
