//
//  NavigateDoneView.swift
//  CustomCamera
//
//  Created by Stan_INT_Tech on 22/08/2025.
//  Copyright © 2025 FAYA Corporation. All rights reserved.
//

import SwiftUI

struct NavigateDoneView: View {

    var onTap: (() -> Void)?

    var body: some View {
        Image(.doneButton)
            .resizable()
            .onTapGesture {
                onTap?()
            }
    }
}

#Preview {
    NavigateDoneView().frame(width: 100, height: 100).background(.red)
}
