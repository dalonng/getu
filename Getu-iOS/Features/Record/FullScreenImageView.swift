//
//  FullScreenImageView.swift
//  Getu-iOS
//
//  Created by 大桥 on 2024/8/5.
//

import SwiftUI

struct FullScreenImageView: View {
  let image: UIImage
  @Binding var isPresented: Bool

  var body: some View {
    ZStack {
      Color.black.edgesIgnoringSafeArea(.all)
      Image(uiImage: image)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .edgesIgnoringSafeArea(.all)
    }
    .overlay(
      Button(action: {
        isPresented = false
      }) {
        Image(systemName: "xmark")
          .foregroundColor(.white)
          .padding()
          .background(Color.black.opacity(0.7))
          .clipShape(Circle())
      }
      .padding(),
      alignment: .topTrailing
    )
  }
}
