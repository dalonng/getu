//
//  RecordDetailView.swift
//  Getu-iOS
//
//  Created by 大桥 on 2024/8/5.
//

import SwiftUI

struct RecordDetailView: View {
  @Environment(\.presentationMode) var presentationMode
  @State private var showingFullScreenImage = false

  let record: TransactionRecord
  let stores: [String]

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        HStack {
          Text("店铺:")
          Text(stores[record.storeIndex])
            .bold()
        }

        HStack {
          Text("日期:")
          Text(record.date, style: .date)
        }

        HStack {
          Text("单价:")
          Text("¥\(String(format: "%.2f", record.unitPrice))")
            .bold()
        }

        HStack {
          Text("数量:")
          Text("\(record.quantity)")
            .bold()
        }

        HStack {
          Text("总价:")
          Text("¥\(String(format: "%.2f", record.totalPrice))")
            .bold()
            .foregroundColor(.blue)
        }

        if let imageData = record.imageData, let uiImage = UIImage(data: imageData) {
          Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
            .frame(height: 200)
            .cornerRadius(10)
            .onTapGesture {
              showingFullScreenImage = true
            }
        }
      }
      .padding()
    }
    .navigationBarTitle("记录详情", displayMode: .inline)
    .navigationBarItems(
      leading: Button(action: {
        presentationMode.wrappedValue.dismiss()
      }) {
        HStack {
          Image(systemName: "chevron.left")
          Text("返回")
        }
        .foregroundColor(.blue)
      }
    )
    .fullScreenCover(isPresented: $showingFullScreenImage) {
      if let image = record.image {
        FullScreenImageView(image: image, isPresented: $showingFullScreenImage)
      }
    }
    .navigationBarBackButtonHidden(true)
  }
}

#Preview {
  NavigationView {
    RecordDetailView(record: TransactionRecord(storeIndex: 0, date: Date(), unitPrice: 10.5, quantity: 5, image: nil), stores: ["店铺一", "店铺二"])
  }
}
