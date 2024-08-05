//
//  ContentView.swift
//  Getu-iOS
//
//  Created by 大桥 on 2024/8/5.
//

import SwiftData
import SwiftUI

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var records: [TransactionRecord]

  let stores = ["店铺一", "店铺二"]

  var groupedRecords: [String: [TransactionRecord]] {
    Dictionary(grouping: records) { record in
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy年MM月"
      return dateFormatter.string(from: record.date)
    }
  }

  var sortedMonths: [String] {
    groupedRecords.keys.sorted(by: >)
  }

  var body: some View {
    NavigationView {
      List {
        ForEach(sortedMonths, id: \.self) { month in
          Section(header: Text(month)) {
            ForEach(groupedRecords[month] ?? []) { record in
              NavigationLink(destination: RecordDetailView(record: record, stores: stores)) {
                RecordRow(record: record, stores: stores)
              }
            }
            .onDelete { indexSet in
              deleteItems(at: indexSet, in: month)
            }
          }
        }
      }
      .navigationTitle("进货记录")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
        ToolbarItem {
          NavigationLink(destination: TransactionRecordPage()) {
            Label("添加记录", systemImage: "plus")
          }
        }
      }
    }
  }

  private func deleteItems(at offsets: IndexSet, in month: String) {
    withAnimation {
      for index in offsets {
        if let record = groupedRecords[month]?[index] {
          modelContext.delete(record)
        }
      }
    }
  }
}

#Preview {
  ContentView()
    .modelContainer(for: TransactionRecord.self, inMemory: true)
}
