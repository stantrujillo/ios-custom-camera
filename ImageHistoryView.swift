//
//  ImageHistoryView.swift
//  CustomCamera
//
//  Created by Stan Trujillo on 20/08/2025.
//

import SwiftUI
import PhotosUI

struct ImageHistoryView: View {

    @ObservedObject var collection: SelectedImageCollection

    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<collection.images.count, id: \.self) { index in
                ImageSlotView(
                    image: collection.images[index]
                )
                .transition(AnyTransition.move(edge: .trailing))
            }
        }.animation(.default, value: collection.images.count)
    }
}

struct ImageSlotView: View {
    let image: UIImage

    var body: some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 88, height: 88)
                .clipped()
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white, lineWidth: 2)
                )
        }
    }
}
