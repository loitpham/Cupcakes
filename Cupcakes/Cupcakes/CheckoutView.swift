//
//  CheckoutView.swift
//  Cupcakes
//
//  Created by Loi Pham on 7/2/21.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    @ObservedObject var orderWrapper: OrderWrapper
    @State private var messageTitle = ""
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text("Your total is $\(orderWrapper.orderStruct.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("Place order") {
                        placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check out", displayMode: .inline)
        .alert(isPresented: $showingConfirmation) {
            Alert(title: Text(messageTitle), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(orderWrapper) else {
            print("Failed to encode order")
            return
        }
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Cannot place your order!  \(error?.localizedDescription ?? "Unknown error").")
                messageTitle = "Error"
                confirmationMessage = "Cannot place your order! \(error?.localizedDescription ?? "Unknown error")"
                showingConfirmation = true
                return
            }
            if let decodedOrder = try? JSONDecoder().decode(OrderWrapper.self, from: data) {
                messageTitle = "Thank you!"
                confirmationMessage = "Your order for \(decodedOrder.orderStruct.quantity) x \(OrderStruct.types[decodedOrder.orderStruct.type].lowercased()) cupcakes is on its way!"
                showingConfirmation = true
            } else {
                print("Invalid response from server.")
            }
            
        }
        .resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order(), orderWrapper: OrderWrapper())
    }
}
