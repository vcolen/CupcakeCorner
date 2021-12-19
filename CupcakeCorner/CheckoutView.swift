//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Victor Colen on 17/12/21.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var showingConnectionError = false
    @State private var errorDescription = ""
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total is \(order.order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("Ok") { }
        }  message: {
            Text(confirmationMessage)
        }
        
        .alert("Failed to complete delivery.", isPresented: $showingConnectionError) {
            Button("ok") { }
        } message: {
            Text(errorDescription)
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func showErrorMessage(error: Error) {
        showingConnectionError = true
    }
    
    func placeOrder() async {
        guard let encoder = try? JSONEncoder().encode(order.order) else {
            print("Couldn't encode data")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoder)
            let decodedOrder = try JSONDecoder().decode(OrderModel.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)X \(OrderModel.types[decodedOrder.type].lowercased()) cupcakes is on it's way!"
            showingConfirmation = true
        } catch {
            errorDescription = error.localizedDescription
            showingConnectionError = true
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
