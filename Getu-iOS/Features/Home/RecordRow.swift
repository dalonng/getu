//
//  RecordRow.swift
//  Getu-iOS
//
//  Created by 大桥 on 2024/8/5.
//

import SwiftUI

struct RecordRow: View {
  let record: TransactionRecord
  let stores: [String]

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text(stores[record.storeIndex])
          .font(.headline)
        Spacer()
        Text(record.date, style: .date)
          .font(.subheadline)
          .foregroundColor(.secondary)
      }

      HStack {
        Text("单价: ¥\(String(format: "%.2f", record.unitPrice))")
        Spacer()
        Text("数量: \(record.quantity)")
      }
      .font(.subheadline)

      Text("总价: ¥\(String(format: "%.2f", record.totalPrice))")
        .font(.subheadline)
        .foregroundColor(.blue)
    }
    .padding(.vertical, 8)
  }
}

#Preview {
  RecordRow(record: TransactionRecord(storeIndex: 0, date: Date(), unitPrice: 10.5, quantity: 5, image: nil), stores: ["店铺一", "店铺二"])
    .previewLayout(.sizeThatFits)
    .padding()
}
