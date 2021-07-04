//
//  AddressView.swift
//  Cupcakes
//
//  Created by Loi Pham on 6/29/21.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order
    @ObservedObject var orderWrapper: OrderWrapper
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $orderWrapper.orderStruct.name)
                TextField("Street Address", text: $orderWrapper.orderStruct.streetAddress)
                TextField("City", text: $orderWrapper.orderStruct.city)
                TextField("Zip", text: $orderWrapper.orderStruct.zip)
            }
            
            Section {
                NavigationLink(
                    destination: CheckoutView(order: order, orderWrapper: orderWrapper),
                    label: {
                        Text("Check out")
                    })
            }
            .disabled(!orderWrapper.orderStruct.hasValidAddress)
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order(), orderWrapper: OrderWrapper())
    }
}
