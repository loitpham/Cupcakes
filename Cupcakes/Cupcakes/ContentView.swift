//
//  ContentView.swift
//  Cupcakes
//
//  Created by Loi Pham on 6/27/21.
//

import SwiftUI

class User: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case name
    }
    @Published var name = "Loi Pham"
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}



struct ContentView: View {
    @ObservedObject var order = Order()
    @ObservedObject var orderWrapper = OrderWrapper()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $orderWrapper.orderStruct.type) {
                        ForEach(0..<OrderStruct.types.count) {
                            Text(OrderStruct.types[$0])
                        }
                    }
                    Stepper(value: $orderWrapper.orderStruct.quantity, in: 3...20) {
                        Text("Number of cakes: \(orderWrapper.orderStruct.quantity)")
                    }
                }
                Section {
                    Toggle(isOn: $orderWrapper.orderStruct.specialRequestEnabled.animation()) {
                        Text("Any special requests?")
                    }
                    if orderWrapper.orderStruct.specialRequestEnabled {
                        Toggle(isOn: $orderWrapper.orderStruct.extraFrosting) {
                            Text("Add extra frosting")
                        }
                        Toggle(isOn: $orderWrapper.orderStruct.addSprinkles) {
                            Text("Add extra sprinkles")
                        }
                    }
                }
                
                Section {
                    NavigationLink(
                        destination: AddressView(order: order, orderWrapper: orderWrapper)) {
                            Text("Delivery details")
                        }
                }
            }
            .navigationBarTitle("Cupcakes")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
