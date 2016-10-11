//
//  NavigateBackView.swift
//  TGTG
//
//  Created by Stan_INT_Tech on 22/08/2025.
//  Copyright © 2025 Too Good To Go. All rights reserved.
//

import SwiftUI

struct NavigateBackView: View {

    var onTap: (() -> Void)?

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(white: 0, opacity: 0.35))
            Image(.navigateBack)
                .resizable()
                .scaleEffect(0.70)
        }
        .onTapGesture {
            onTap?()
        }
    }
}

#Preview {
    NavigateBackView().frame(width: 100, height: 100).background(.red)
}
