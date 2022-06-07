//
//  DotLabel.swift
//
//
//  Created by yueyue max on 2022/6/7.
//

import SwiftUI

struct DotLabel: View {
    var type: ChartVisualType
    var points: [CGPoint]
    var dotLabelType: DotLabelType
   
    var body: some View {
        dotlLabel
            .rotationEffect(.degrees(180), anchor: .center)
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
    }
    
    private var dotlLabel: some View {
        switch dotLabelType {
            case .none:
                return AnyView(EmptyView())
            case .circle(let c, let l):
                switch type {
                    case .outline(let color, let lineWidth):
                        return AnyView(dotView(points: points, lineWidth: l ?? lineWidth, color: c ?? color))
                    case .filled(let color, let lineWidth):
                        return AnyView(dotView(points: points, lineWidth: l ?? lineWidth, color: c ?? color))
                    case .customFilled(let color, let lineWidth, _):
                        return AnyView(dotView(points: points, lineWidth: l ?? lineWidth, color: c ?? color))
                }
        }
    }
    
    private func offset(points: [CGPoint], indexInPoints: Int, lineWidth: CGFloat) -> (x: CGFloat, y: CGFloat) {
        let x = points[indexInPoints].x - lineWidth
        let y = points[indexInPoints].y - lineWidth
        return (x, y)
    }
    
    private func dotView(points: [CGPoint], lineWidth: CGFloat, color: Color) -> some View {
        GeometryReader { _ in
            ZStack {
                ForEach(0 ..< points.count, id: \.self) { index in
                    let offset = offset(points: points, indexInPoints: index, lineWidth: lineWidth)
                    ZStack {
                        Circle()
                            .frame(width: lineWidth, height: lineWidth)
                            .offset(x: offset.x, y: offset.y)
                            .foregroundColor(.white)
                        Circle()
                            .stroke(color, style: StrokeStyle(lineWidth: lineWidth))
                            .frame(width: lineWidth * 2, height: lineWidth * 2)
                            .offset(x: offset.x, y: offset.y)
                    }
                }
            }
        }
    }
}
