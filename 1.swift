import Foundation

struct Product {
    let id: UUID
    var name: String
    var price: Double
    var description: String
    var stock: Int

    var displayPrice: String {
        return String(format: "$%.2f", price)
    }

    mutating func applyDiscount(_ percent: Double) {
        guard percent > 0 && percent <= 100 else {
            print("error discount %.")
            return
        }
        price -= price * (percent / 100)
    }
}


struct CartItem {
    let product: Product
    var quantity: Int

   
    var subtotal: Double {
        return Double(quantity) * product.price
    }
}

class ShoppingCart {
    private(set) var items: [CartItem] = []

  
    func addItem(_ product: Product, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += quantity
        } else {
            let newItem = CartItem(product: product, quantity: quantity)
            items.append(newItem)
        }
    }

    func removeItem(by productID: UUID) {
        items.removeAll { $0.product.id == productID }
    }

    
    var totalPrice: Double {
        return items.reduce(0) { $0 + $1.subtotal }
    }

    
    func clearCart() {
        items.removeAll()
    }

    // summary
    func printCartSummary() {
        print("\n🛒 Shopping Cart Summary:")
        if items.isEmpty {
            print(" cart is empty")
        } else {
            for item in items {
                print("- \(item.product.name) x\(item.quantity): \(item.product.displayPrice) each, subtotal: $\(String(format: "%.2f", item.subtotal))")
            }
            print("TOTAL: $\(String(format: "%.2f", totalPrice))\n")
        }
    }
}



struct Address {
    var street: String
    var city: String
    var country: String
}

struct Order {
    let id: UUID
    let items: [CartItem]
    let shippingAddress: Address
    let totalAmount: Double
    let date: Date


    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

  
    func printOrderSummary() {
        print(" Order Summary:")
        print("Order ID: \(id.uuidString.prefix(8))...")
        print("Date: \(formattedDate)")
        print("Shipping to: \(shippingAddress.street), \(shippingAddress.city), \(shippingAddress.country)")
        print("Total Amount: $\(String(format: "%.2f", totalAmount))")
        print("Items:")
        for item in items {
            print(" - \(item.product.name) x\(item.quantity)")
        }
        print("Thats all !")
    }
}


class User {
    let id: UUID
    var name: String
    var email: String
    var cart: ShoppingCart
    var orderHistory: [Order]

    init(name: String, email: String) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.cart = ShoppingCart()
        self.orderHistory = []
    }

    func placeOrder(address: Address) {
        let newOrder = Order(
            id: UUID(),
            items: cart.items,
            shippingAddress: address,
            totalAmount: cart.totalPrice,
            date: Date()
        )
        orderHistory.append(newOrder)
        newOrder.printOrderSummary()
        cart.clearCart()
    }

    func printOrderHistory() {
        print(" Order History for \(name):")
        if orderHistory.isEmpty {
            print("No past orders yet.")
        } else {
            for order in orderHistory {
                print("- order \(order.id.uuidString.prefix(8)) • \(order.formattedDate) • $\(String(format: "%.2f", order.totalAmount))")
            }
        }
    }
}


func runDemo() {
    print(" iOS lab 3")

    
    var ipad = Product(id: UUID(), name: "ipad air", price: 1199.0, description: "High Tech things", stock: 6)
    let iphone = Product(id: UUID(), name: "iPhone 17pro", price: 1099.0, description: "Latest iPhone model", stock: 10)

    
    ipad.applyDiscount(10)

  
    let user = User(name: "Maral", email: "maral@gmail.com")

    
    user.cart.addItem(ipad, quantity: 1)
    user.cart.addItem(iphone, quantity: 2)

    
    user.cart.printCartSummary()

    let address = Address(street: "Aksai 3, dom 5", city: "Almaty", country: "Kazakhstan")
    user.placeOrder(address: address)

    user.printOrderHistory()
}

runDemo()
