//
// Copyright (c) 2025 and Confidential to Eric Ford Consulting All rights reserved.
//

import SwiftUI

struct PulseBrain: View {
    @State private var animating = false
    var body: some View {
        Image(systemName: "brain")
            .scaleEffect(animating ? 1.2: 1)
            .animation(Animation.default.repeatForever(autoreverses: true))
            .onAppear {
                self.animating = true
            }
    }
}

#Preview {
    PulseBrain()
}
