//
// Copyright (c) 2025 and Confidential to Eric Ford Consulting All rights reserved.
//
/*
 Based on Fatbobman's RatioSplitHStack
 */

import SwiftUI

struct RatioSplitVStack<T, B>: View where T: View, B: View {
    let topWidthRatio: CGFloat
    let topContent: T
    let bottomContent: B
    init(topWidthRatio: CGFloat, @ViewBuilder topContent: @escaping () -> T, @ViewBuilder bottomContent: @escaping () -> B) {
        self.topWidthRatio = topWidthRatio
        self.topContent = topContent()
        self.bottomContent = bottomContent()
    }

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                Color.clear
                    .frame(width: proxy.size.height * topWidthRatio)
                    .overlay(topContent)
                Color.clear
                    .overlay(bottomContent)
            }
        }
    }
}

struct RatioSplitHStack<L, R>: View where L: View, R: View {
    let leftWidthRatio: CGFloat
    let leftContent: L
    let rightContent: R
    init(leftWidthRatio: CGFloat, @ViewBuilder leftContent: @escaping () -> L, @ViewBuilder rightContent: @escaping () -> R) {
        self.leftWidthRatio = leftWidthRatio
        self.leftContent = leftContent()
        self.rightContent = rightContent()
    }

    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                Color.clear
                    .frame(width: proxy.size.width * leftWidthRatio)
                    .overlay(leftContent)
                Color.clear
                    .overlay(rightContent)
            }
        }
    }
}
