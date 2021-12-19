//
//  Order.swift
//  CupcakeCorner
//
//  Created by Victor Colen on 17/12/21.
//

import Foundation

class Order: ObservableObject {
    @Published var order = OrderModel()
}

struct OrderModel: Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAdress: Bool {
        if name.trimmingCharacters(in: .whitespaces) == "" || streetAddress.trimmingCharacters(in: .whitespaces) == "" || city.trimmingCharacters(in: .whitespaces) == "" || zip.trimmingCharacters(in: .whitespaces) == "" {
            return false
        }
        
        return true
    }
    
    var cost: Double {
        //$2 for cake
        var cost = Double(quantity) * 2
        
        //complicated cakes cost more
        cost += (Double(type) / 2)
        
        //$1 /cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }
        
        //$0.50 for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
}
