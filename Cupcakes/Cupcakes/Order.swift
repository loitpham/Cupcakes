//
//  Order.swift
//  Cupcakes
//
//  Created by Loi Pham on 6/29/21.
//

import Foundation

class Order: ObservableObject {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    @Published var type = 0
    @Published var quantity = 3
    @Published var specialRequestEnabled = false {
        didSet {
            if !specialRequestEnabled {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false
}
