//
// Copyright (c) 2024 and Confidential to Eric Ford Consulting All rights reserved.
//

import SwiftUI

struct ManView: View {
    var viewModel: ViewModel
    class ViewModel {
        
        let man: Man
        let manColor: Color
        let manSize: CGFloat
        let centerX: CGFloat
        let centerY: CGFloat
        let girth: CGFloat
        let size: CGSize
        var abilitySize, shortProng, longProng: CGFloat
        var skinnyProng, fatProng, jumpProng: CGFloat

        init(size: CGSize, man: Man)
        {
            self.size = size
            self.manSize = size.width // always same as height
            self.man = man
//            if man.wounded {
//                print("wounded man")
//            }
            if man.player.name == "Red"
            {
                manColor = .red
            }
            else
            {
                manColor = .blue
            }
            centerX = manSize / 2
            centerY = manSize / 2
            girth = manSize / 8
            abilitySize = size.width
            shortProng = abilitySize / 5
            longProng = abilitySize / 3
            skinnyProng = 1
            jumpProng = 2
            fatProng = 3
//            if man.piece.name == "Queen" {
//                print("man has \(man.abilities.count) abilities")
//            }
        }
        
        func getCenter() -> CGPoint {
            CGPoint(x: centerX, y: centerY)
        }
        
        func getShortProng(ability: Ability) -> CGPoint {
            CGPoint(x: centerX + (CGFloat(ability.xOffset) * shortProng), y: centerY + (CGFloat(ability.yOffset) * shortProng))
        }

        func getShortProngPath(ability: Ability) -> Path {
            return Path { path1 in
                path1.move(to: getCenter())
                path1.addLine(to: getShortProng(ability: ability))
                path1.closeSubpath()
            }
        }
        
        func printQueen() {
            if man.piece.name == "Queen" {
                print("man.abilities.count \(man.abilities.count)")
                for ability in man.abilities {
                    print("ability.abilityType \(ability.abilityType) \(ability.xOffset) \(ability.yOffset)")
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(viewModel.manColor)
                .frame(width: viewModel.girth, height: viewModel.girth)
//            let _ = viewModel.printQueen()
            ForEach(viewModel.man.abilities) { ability in
                switch(ability.abilityType)
                {
                case .Fat:
                    drawFatProng(ability: ability)
                case .Slide:
                    drawSlideProng(ability: ability)
                case .Step:
                    viewModel.getShortProngPath(ability: ability).stroke(viewModel.manColor, lineWidth: viewModel.skinnyProng)
                default: // case .Jump:
                    viewModel.getShortProngPath(ability: ability).stroke(
                        viewModel.manColor, lineWidth: viewModel.skinnyProng
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    func drawSlideProng(ability: Ability) -> some View {
        if !ability.demoted {
            viewModel.getShortProngPath(ability: ability).stroke(viewModel.manColor, lineWidth: viewModel.fatProng)
            Path { path2 in
                path2.move(to: CGPoint(x: viewModel.centerX + (CGFloat(ability.xOffset) * viewModel.shortProng), y: viewModel.centerY + (CGFloat(ability.yOffset) * viewModel.shortProng)))
                path2.addLine(to: CGPoint(x: viewModel.centerX + (CGFloat(ability.xOffset) * viewModel.longProng), y: viewModel.centerY + (CGFloat(ability.yOffset) * viewModel.longProng)))
                path2.closeSubpath()
            }.stroke(viewModel.manColor, lineWidth: viewModel.skinnyProng)
        }
        else {
            viewModel.getShortProngPath(ability: ability).stroke(viewModel.manColor, lineWidth: viewModel.skinnyProng)
        }
    }
    
    @ViewBuilder
    func drawFatProng(ability: Ability) -> some View {
        if !ability.demoted {
            viewModel.getShortProngPath(ability: ability).stroke(viewModel.manColor, lineWidth: viewModel.fatProng)
        }
        else {
            viewModel.getShortProngPath(ability: ability).stroke(viewModel.manColor, lineWidth: viewModel.skinnyProng)
        }
    }
}

#Preview {
    ManView(viewModel: ManView.ViewModel(size: CGSize(width: 100, height: 100), man: Man(piece: Piece.star(), player: Player(direction: Direction.North, name: "Red", darkSquareHiliteColor: reddishDarkGreen, lightSquareHiliteColor: reddishLightGreen))))
}
