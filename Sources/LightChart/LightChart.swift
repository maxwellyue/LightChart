import SwiftUI

public struct LightChartView: View {
    
    private let data: [Double]
    private let type: ChartType
    private let visualType: ChartVisualType
    private let offset: Double
    private let currentValueLineType: CurrentValueLineType
    
    public init(
        data: [Double],
        type: ChartType = .line,
        visualType: ChartVisualType = .outline(color: .red, lineWidth: 2),
        offset: Double = 0,
        currentValueLineType: CurrentValueLineType = .none
    ) {
        self.data = data
        self.type = type
        self.visualType = visualType
        self.offset = offset
        self.currentValueLineType = currentValueLineType
    }
    
    public var body: some View {
        GeometryReader { reader in
            chart(
                withFrame: CGRect(
                    x: 0,
                    y: 0,
                    width: reader.frame(in: .local).width ,
                    height: reader.frame(in: .local).height
                )
            )
        }
    }
    
    private func chart(withFrame frame: CGRect) -> AnyView {
        switch type {
            case .line:
                return AnyView(
                    LineChart(
                        data: data,
                        frame: frame,
                        visualType: visualType,
                        offset: offset,
                        currentValueLineType: currentValueLineType
                    )
                )
            case .curved:
                return AnyView(
                    CurvedChart(
                        data: data,
                        frame: frame,
                        visualType: visualType,
                        offset: offset,
                        currentValueLineType: currentValueLineType
                    )
                )
        }
    }
}

struct LightChartView_Previews: PreviewProvider {

    static let data: [Double] = [30, 40, 35, 42, 50, 52, 50, 51, 45, 62, 58, 64, 58, 70, 68, 79, 72, 85, 80, 87, 78, 82, 90, 95, 85, 93, 90, 100]
    
    static var previews: some View {
        Group {
            if #available(iOS 15.0, *) {
                LightChartView(
                    data: data,
                    visualType: .filled(color: .mint, lineWidth: 3),
                    offset: 0.3
                )
                    .frame(width: 600, height: 200)
            } else {
                LightChartView(
                    data: data,
                    visualType: .filled(color: .green, lineWidth: 3),
                    offset: 0.3
                )
                    .frame(width: 600, height: 200)
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
