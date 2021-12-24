//
//  FatChart.swift
//  
//
//  Created by Alexey Pichukov on 24.12.2021.
//

import SwiftUI

public struct FatChart: View {
    
    private let data: [Double]
    private let secondaryData: [Double]?
    private let bottomLabels: [String]?
    private let verticalLabels: [String]?
    private let leftVerticalLabels: Bool
    private let showVerticalLines: Bool
    private let showHorizontalLines: Bool
    
    @State private var temp: String = ""
    
    public init(
        data: [Double],
        secondaryData: [Double]? = nil,
        bottomLabels: [String]?,
        verticalLabels: [String]?,
        leftVerticalLabels: Bool = false,
        showVerticalLine: Bool = false,
        showHorizontalLines: Bool = false
    ) {
        self.data = data
        self.secondaryData = secondaryData
        self.bottomLabels = bottomLabels
        self.verticalLabels = verticalLabels
        self.leftVerticalLabels = leftVerticalLabels
        self.showVerticalLines = showVerticalLine
        self.showHorizontalLines = showHorizontalLines
    }
    
    public var body: some View {
        HStack {
            if leftVerticalLabels, let labels = verticalLabels {
                verticalLabels(labels: labels)
            }
            
            VStack {
                if #available(iOS 15.0, *) {
                    GeometryReader { proxy in
                        ZStack {
                            
                            // Vertical lines
                            if showVerticalLines, let count = bottomLabels?.count {
                                ForEach(0..<count + 1) { index in
                                    linePath(
                                        start: bottomLabelPositions(
                                            width: proxy.size.width,
                                            count: count
                                        )[index],
                                        end: CGPoint(x: bottomLabelPositions(
                                            width: proxy.size.width,
                                            count: count
                                        )[index].x, y: proxy.size.height)
                                    )
                                        .stroke(
                                            Color.secondary.opacity(0.3),
                                            style: StrokeStyle(
                                                lineWidth: 1,
                                                dash: [6]
                                            )
                                        )
                                }
                            }
                            
                            // Horizontal lines
                            if showHorizontalLines, let count = verticalLabels?.count {
                                ForEach(0..<count + 1) { index in
                                    linePath(
                                        start: verticalLabelPositions(
                                            height: proxy.size.height,
                                            count: count
                                        )[index],
                                        end: CGPoint(
                                            x: proxy.size.width,
                                            y: verticalLabelPositions(
                                                height: proxy.size.height,
                                                count: count
                                            )[index].y
                                        )
                                    )
                                        .stroke(
                                            Color.secondary.opacity(0.3),
                                            style: StrokeStyle(
                                                lineWidth: 1,
                                                dash: [6]
                                            )
                                        )
                                }
                            }
                            
                            // Secondary chart
                            if let secondaryData = secondaryData {
                                LightChartView(
                                    data: secondaryData,
                                    visualType: .filled(color: Color.secondary.opacity(0.6), lineWidth: 2),
                                    offset: 0.2
                                )
                            }
                            
                            // Main chart
                            LightChartView(
                                data: data,
                                visualType: .outline(color: .mint, lineWidth: 3),
                                offset: 0.3
                            )
                            
                            // Bottom line
                            if let count = bottomLabels?.count {
                                linePath(
                                    start: CGPoint(
                                        x: 0,
                                        y: proxy.size.height
                                    ),
                                    end: CGPoint(
                                        x: proxy.size.width,
                                        y: proxy.size.height
                                    )
                                )
                                    .stroke(Color.secondary.opacity(0.5))
                                
                                ForEach(0..<count + 1) { index in
                                    Circle()
                                        .frame(width: 5, height: 5, alignment: .center)
                                        .foregroundColor(Color.secondary)
                                        .position(
                                            x: bottomLabelPositions(
                                                width: proxy.size.width,
                                                count: count
                                            )[index].x,
                                            y: proxy.size.height
                                        )
                                }
                            }
                        }
                    }
                } else {
                    Text("Chart could be here")
                }
                
                if let labels = bottomLabels {
                    GeometryReader { proxy in
                        Group {
                            Spacer()
                            ForEach(Array(labels.enumerated()), id: \.offset) { index, label in
                                Text(label)
                                    .multilineTextAlignment(.center)
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                                    .frame(
                                        width: bottomLabelWidth(
                                            width: proxy.size.width,
                                            count: labels.count
                                        ),
                                        height: proxy.size.height
                                    )
                                    .position(
                                        x: bottomLablePositionX(
                                            index: index,
                                            count: labels.count,
                                            width: proxy.size.width
                                        ),
                                        y: proxy.size.height / 2
                                    )
                            }
                        }
                    }
                    .frame(width: .infinity, height: 40, alignment: .center)
                }
            }
            
            if !leftVerticalLabels, let labels = verticalLabels {
                verticalLabels(labels: labels)
            }
        }
        .frame(width: 500, height: 200)
    }
    
    private func verticalLabels(labels: [String]) -> some View {
        GeometryReader { proxy in
            Group {
                ForEach(Array(labels.reversed().enumerated()), id: \.offset) { index, label in
                    Text(label)
                        .multilineTextAlignment(.center)
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .frame(
                            width: proxy.size.width,
                            height: verticalLabelHeight(
                                height: proxy.size.height - 40,
                                count: labels.count
                            )
                        )
                        .position(
                            x: proxy.size.width / 2,
                            y: verticalLablePositionY(
                                index: index,
                                count: labels.count,
                                height: proxy.size.height - 48 + verticalLabelHeight(
                                    height: proxy.size.height - 40,
                                    count: labels.count
                                ) / 2
                            )
                        )
                }
            }
        }
        .frame(width: 60, height: .infinity, alignment: .center)
    }
    
    private func bottomLabelWidth(width: CGFloat, count: Int) -> CGFloat {
        return width / CGFloat(count)
    }
    
    private func verticalLabelHeight(height: CGFloat, count: Int) -> CGFloat {
        return height / CGFloat(count)
    }
    
    private func bottomLablePositionX(
        index: Int,
        count: Int,
        width: CGFloat
    ) -> CGFloat {
        let step = width / CGFloat(count)
        return CGFloat(index) * step + CGFloat(step / 2)
    }
    
    private func verticalLablePositionY(
        index: Int,
        count: Int,
        height: CGFloat
    ) -> CGFloat {
        let step = height / CGFloat(count)
        return CGFloat(index) * step + CGFloat(step / 2)
    }
    
    private func linePath(start: CGPoint, end: CGPoint) -> Path {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
    
    private func bottomLabelPositions(width: CGFloat, count: Int) -> [CGPoint] {
        var result: [CGPoint] = []
        let step = width / CGFloat(count)
        for index in 0...count {
            result.append(CGPoint(x: step * CGFloat(index), y: 0))
        }
        return result
    }
    
    private func verticalLabelPositions(height: CGFloat, count: Int) -> [CGPoint] {
        var result: [CGPoint] = []
        let step = height / CGFloat(count)
        for index in 0...count {
            result.append(CGPoint(x: 0, y: step * CGFloat(index)))
        }
        return result
    }
}

struct FatChart_Previews: PreviewProvider {
    
    static let data: [Double] = [30, 40, 35, 32, 45, 40, 60, 58, 45, 62, 58, 64, 58, 70, 68, 79, 72, 85, 80, 87, 78, 82, 90, 95, 85, 93, 90, 100]
    static let secondaryData: [Double] = [20, 20, 25, 25, 25, 25, 25, 35, 35, 35, 35, 35, 35, 40, 40, 50, 50, 50, 65, 65, 70, 70, 70, 75, 80, 85, 95, 95]
    static let bottomLabels = ["Q1 2021", "Q2 2021", "Q3 2021", "Q4 2021"]
    static let verticalLabels = ["0", "10 000", "20 000", "30 000"]
    
    static var previews: some View {
        Group {
            FatChart(
                data: data,
                secondaryData: secondaryData,
                bottomLabels: bottomLabels,
                verticalLabels: verticalLabels,
                leftVerticalLabels: true,
                showVerticalLine: true,
                showHorizontalLines: true
            )
            FatChart(
                data: data,
                secondaryData: secondaryData,
                bottomLabels: bottomLabels,
                verticalLabels: verticalLabels,
                showVerticalLine: true,
                showHorizontalLines: true
            )
                .preferredColorScheme(.dark)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
