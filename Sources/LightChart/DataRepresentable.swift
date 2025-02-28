//
//  DataRepresentable.swift
//
//
//  Created by Alexey Pichukov on 19.08.2020.
//

import CoreGraphics
import Foundation
import SwiftUI

protocol DataRepresentable {
    func points(forData data: [Double?], frame: CGRect, offset: Double, lineWidth: CGFloat) -> [CGPoint]
    func lineWidth(visualType: ChartVisualType) -> CGFloat
}

extension DataRepresentable {
    func points(forData data: [Double?], frame: CGRect, offset: Double, lineWidth: CGFloat) -> [CGPoint] {
        let dataNoNil = data.compactMap { $0 }
        var vector = Math.stretchOut(Math.norm(dataNoNil))
        if offset != 0 {
            vector = Math.stretchIn(vector, offset: offset)
        }
        var points: [CGPoint] = []
        let isSame = sameValues(in: vector)

        // get x values
        var xs = [Int]()
        for i in 0..<data.count {
            if data[i] != nil {
                xs.append(i)
            }
        }

        for i in 0..<vector.count {
            let x = frame.size.width / CGFloat(data.count - 1) * CGFloat(xs[i])

            let y = isSame ? frame.size.height / 2 : (frame.size.height - lineWidth) * CGFloat(vector[i]) + lineWidth / 2
            points.append(CGPoint(x: x, y: y))
        }
        return points
    }

    func lineWidth(visualType: ChartVisualType) -> CGFloat {
        switch visualType {
            case .outline(_, let lineWidth):
                return lineWidth
            case .filled(_, let lineWidth):
                return lineWidth
            case .customFilled(_, let lineWidth, _):
                return lineWidth
        }
    }

    private func sameValues(in vector: [Double]) -> Bool {
        guard let prev = vector.first else {
            return true
        }
        for value in vector {
            if value != prev {
                return false
            }
        }
        return true
    }
}

struct LightChartView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LightChartView(data: [12, 12, nil, nil, nil, 12, 10, 16],
                           type: .curved,
                           visualType: .filled(color: .accentColor, lineWidth: 3),
                           dotLabelType: .circle(color: .accentColor, lineWidth: 3),
                           currentValueLineType: .dash(color: .accentColor, lineWidth: 1, dash: [4]))
                .frame(height: 200)
                .padding()

            LightChartView(data: [12, 12, nil, nil, nil, 12, 10, 16],
                           type: .line,
                           visualType: .filled(color: .accentColor, lineWidth: 3),
                           dotLabelType: .circle(color: .accentColor, lineWidth: 3),
                           currentValueLineType: .dash(color: .accentColor, lineWidth: 1, dash: [4]))
                .frame(height: 200)
                .padding()
        }
    }
}
