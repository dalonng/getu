import Foundation
import SwiftData
import SwiftUI

@Model
final class TransactionRecord {
  var id: UUID
  var storeIndex: Int
  var date: Date
  var unitPrice: Double
  var quantity: Int
  var totalPrice: Double
  var imageData: Data?

  init(storeIndex: Int, date: Date, unitPrice: Double, quantity: Int, image: Data? = nil) {
    self.id = UUID()
    self.storeIndex = storeIndex
    self.date = date
    self.unitPrice = unitPrice
    self.quantity = quantity
    self.totalPrice = unitPrice * Double(quantity)
    self.imageData = image
  }
}

extension TransactionRecord {
  var image: UIImage? {
    guard let data = imageData else { return nil }
    return UIImage(data: data) ?? UIImage()
  }
}
