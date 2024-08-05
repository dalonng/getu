import SwiftData
import SwiftUI

struct TransactionRecordPage: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.presentationMode) var presentationMode
  @State private var showingImagePicker = false
  @State private var showingFullScreenImage = false
  @State private var showAlert = false
  @State private var alertTitle = ""
  @State private var alertMessage = ""
    
  @State private var selectedStore = 0
  @State private var date = Date()
  @State private var unitPrice = ""
  @State private var quantity = ""
  @State private var image: UIImage?
    
  let stores = ["店铺一", "店铺二"]
    
  var totalPrice: Double {
    (Double(unitPrice) ?? 0) * (Double(quantity) ?? 0)
  }
    
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading, spacing: 20) {
          HStack(spacing: 10) {
            Text("店铺")
            Picker("选择店铺", selection: $selectedStore) {
              ForEach(0 ..< stores.count, id: \.self) { index in
                Text(stores[index]).tag(index)
              }
            }
            .pickerStyle(SegmentedPickerStyle())
          }
                    
          HStack(spacing: 10) {
            Text("日期")
            DatePicker("", selection: $date, displayedComponents: .date)
              .labelsHidden()
          }
                    
          HStack(spacing: 10) {
            Text("单价")
            TextField("输入单价", text: $unitPrice)
              .keyboardType(.decimalPad)
              .textFieldStyle(RoundedBorderTextFieldStyle())
          }
                    
          HStack(spacing: 10) {
            Text("数量")
            TextField("输入数量", text: $quantity)
              .keyboardType(.numberPad)
              .textFieldStyle(RoundedBorderTextFieldStyle())
          }
                    
          HStack(spacing: 10) {
            Text("总价")
            Text(String(format: "%.2f", totalPrice))
              .padding()
              .frame(maxWidth: .infinity, alignment: .leading)
              .background(Color.gray.opacity(0.2))
              .cornerRadius(8)
          }
                    
          HStack(spacing: 10) {
            Text("图片")
            Button(action: {
              showingImagePicker = true
            }) {
              Text(image == nil ? "添加图片" : "更换图片")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
          }
          if let image {
            Image(uiImage: image)
              .resizable()
              .scaledToFit()
              .frame(height: 200)
              .cornerRadius(8)
              .onTapGesture {
                showingFullScreenImage = true
              }
          }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
      }
      .navigationBarTitle("录入进货信息", displayMode: .inline)
      .navigationBarItems(
        leading: Button(action: {
          presentationMode.wrappedValue.dismiss()
        }) {
          HStack {
            Image(systemName: "chevron.left")
            Text("返回")
          }
          .foregroundColor(.blue)
        },
        trailing: Button("保存") {
          saveRecord()
        }
      )
      .sheet(isPresented: $showingImagePicker) {
        ImagePicker(image: $image)
      }
      .fullScreenCover(isPresented: $showingFullScreenImage) {
        if let image {
          FullScreenImageView(image: image, isPresented: $showingFullScreenImage)
        }
      }
      .alert(isPresented: $showAlert) {
        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
      }
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .navigationBarBackButtonHidden(true)
  }
    
  private func saveRecord() {
    guard let unitPrice = Double(unitPrice), let quantity = Int(quantity) else {
      showAlert(title: "输入错误", message: "请确保单价和数量都已正确输入")
      return
    }
        
    let imageData = image?.jpegData(compressionQuality: 0.8)
    let newRecord = TransactionRecord(storeIndex: selectedStore, date: date, unitPrice: unitPrice, quantity: quantity, image: imageData)
        
    modelContext.insert(newRecord)
        
    do {
      try modelContext.save()
      showAlert(title: "保存成功", message: "记录已成功保存")
      resetForm()
      presentationMode.wrappedValue.dismiss()
    } catch {
      showAlert(title: "保存失败", message: "无法保存记录：\(error.localizedDescription)")
    }
  }
    
  private func resetForm() {
    selectedStore = 0
    date = Date()
    unitPrice = ""
    quantity = ""
    image = nil
  }
    
  private func showAlert(title: String, message: String) {
    alertTitle = title
    alertMessage = message
    showAlert = true
  }
}
