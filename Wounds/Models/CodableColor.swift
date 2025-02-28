//
// Copyright (c) 2024 and Confidential to Eric Ford Consulting All rights reserved.
//

import SwiftUI

struct CodableColor : Codable {
    let red: Double
    let green: Double
    let blue: Double
    
    func getSwiftUIColor() -> Color {
        return Color(red: red, green: green, blue: blue)
    }
}
