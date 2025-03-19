//
// Copyright (c) 2024 and Confidential to Eric Ford Consulting All rights reserved.
//

import SwiftUI
import WoundsEngine

struct AbilityView: View {
    @ObservedObject var viewModel: ViewModel
    class ViewModel: ObservableObject {
        var ability: Ability
        var centerX, centerY, abilitySize, shortProng, longProng: CGFloat
        var skinnyProng, fatProng, jumpProng: CGFloat
        var abilityColor: Color
        
        init(ability: Ability, size: CGSize, color: Color)
        {
            self.ability = ability
            self.abilityColor = color
            self.abilitySize = size.width
            self.centerX = self.abilitySize / 2
            self.centerY = self.abilitySize / 2
            self.shortProng = self.abilitySize / 5
            self.longProng = self.abilitySize / 3
            self.skinnyProng = 1
            self.jumpProng = 2
            self.fatProng = 3
        }

        func getCenter() -> CGPoint {
            CGPoint(x: centerX, y: centerY)
        }
        
        func getShortProng() -> CGPoint {
            CGPoint(x: centerX + (CGFloat(ability.xOffset) * shortProng), y: centerY + (CGFloat(ability.yOffset) * shortProng))
        }
    }
    
    var body: some View {
            switch(viewModel.ability.abilityType)
            {
            case .Fat:
                Path { path1 in
                    path1.move(to: viewModel.getCenter())
                    path1.addLine(to: viewModel.getShortProng())
                    path1.closeSubpath()
                }.stroke(viewModel.abilityColor, lineWidth: viewModel.fatProng)
            case .Slide:
                Path { path1 in
                    path1.move(to: CGPoint(x: self.viewModel.centerX, y: self.viewModel.centerY))
                    path1.addLine(to: CGPoint(x: self.viewModel.centerX + (CGFloat(viewModel.ability.xOffset) * self.viewModel.shortProng), y: self.viewModel.centerY + (CGFloat(viewModel.ability.yOffset) * self.viewModel.shortProng)))
                    path1.closeSubpath()
                }.stroke(viewModel.abilityColor, lineWidth: viewModel.fatProng)
                if !viewModel.ability.demoted {
                    Path { path2 in
                        path2.move(to: CGPoint(x: self.viewModel.centerX + (CGFloat(viewModel.ability.xOffset) * self.viewModel.shortProng), y: self.viewModel.centerY + (CGFloat(viewModel.ability.yOffset) * self.viewModel.shortProng)))
                        path2.addLine(to: CGPoint(x: self.viewModel.centerX + (CGFloat(viewModel.ability.xOffset) * self.viewModel.longProng), y: self.viewModel.centerY + (CGFloat(viewModel.ability.yOffset) * self.viewModel.longProng)))
                        path2.closeSubpath()
                    }.stroke(viewModel.abilityColor, lineWidth: viewModel.skinnyProng)
                }
            case .Step:
                Path { path1 in
                    path1.move(to: viewModel.getCenter())
                    path1.addLine(to: viewModel.getShortProng())
                    path1.closeSubpath()
                }.stroke(viewModel.abilityColor, lineWidth: viewModel.skinnyProng)
            default: // case .Jump:
                Path { path1 in
                    path1.move(to: viewModel.getCenter())
                    path1.addLine(to: CGPoint(x: self.viewModel.centerX + (CGFloat(viewModel.ability.xOffset) * self.viewModel.shortProng), y: self.viewModel.centerY + (CGFloat(viewModel.ability.yOffset) * self.viewModel.shortProng)))
                    path1.closeSubpath()
                }.stroke(
                    viewModel.abilityColor, lineWidth: viewModel.skinnyProng
                )
            }
    }
}

#Preview {
    let ability = Ability(abilityType: .Step, xOffset: 1, yOffset: 1)
    AbilityView(viewModel: AbilityView.ViewModel(ability: ability, size: CGSize(width: 100, height: 100), color: .red))
}
