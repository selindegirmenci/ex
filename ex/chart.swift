import SwiftUI
import Charts

struct lmaoContentView: View {
    @State private var data: [(String, Double)] = []
    @State private var test = [10, 20, 15, 42, 54, 9, 7, 80, 124, 25, 235, 32, 32, 32, 20, 56, 87]
    @State private var index = 0
    @State private var timer: Timer?

    var body: some View {
        VStack {
            ZStack {
                // background
                Rectangle()
                    .fill(Color(red: 1.0, green: 0.98, blue: 0.9))
                    .frame(width: 950, height: 550)
                
                VStack {
                    Text("Temperature Reading")
                        .font(.title)
                        .padding(.bottom, 10)
                        .foregroundStyle(Color.black)
                    
                    HStack {
                        Text("Temperature")
                            .rotationEffect(.degrees(-90))
                            .font(.system(size: 20))
                            .padding(.trailing, 10)
                            .foregroundStyle(Color.black)
                        
                        VStack {
                            Chart {
                                ForEach(data, id: \.0) { point in
                                    LineMark(
                                        x: .value("Time", point.0),
                                        y: .value("Value", point.1)
                                    )
                                    .foregroundStyle(Color.blue)
                                    .interpolationMethod(.cardinal)
                                    .symbol {
                                        Circle()
                                            .fill(Color.blue)
                                            .frame(width: 12, height: 12)
                                            .overlay {
                                                // point.1 for the y-value of the data point
                                                Text("\(point.1, specifier: "%.2f")")
                                                    .frame(width: 50)
                                                    .font(.system(size: 12, weight: .medium))
                                                    .offset(y: -15)
                                            }
                                    }
                                }
                            }
                            .chartYAxis {
                                AxisMarks { value in
                                    AxisValueLabel {
                                        Text("\(value.as(Double.self) ?? 0, specifier: "%.2f")")
                                            .font(.system(size: 12))
                                            .foregroundStyle(Color.black)
                                    }
                                    AxisGridLine()
                                        .foregroundStyle(Color.black.opacity(1))
                                }
                            }
                            .chartXAxis {
                                AxisMarks(values: data.map { $0.0 }) { value in
                                    AxisGridLine()
                                        .foregroundStyle(Color.black.opacity(1))
                                }
                                AxisMarks { value in
                                    AxisValueLabel {
                                        let timeString = value.as(String.self) ?? ""
                                        Text(timeString)
                                            .font(.system(size: 10))
                                            .foregroundStyle(Color.black)
                                    }
                                }
                            }
                            .frame(width: 800, height: 400)
                            .padding()
                            
                            Text("Time")
                                .font(.system(size: 20))
                                .padding(.top, 10)
                                .foregroundStyle(Color.black)
                        }
                    }
                }
            }
        }
        .onAppear {
            // Interval timer when the view appears
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                addPoint()
            }
        }
        .onDisappear {
            // Invalidate the timer when the view disappears
            timer?.invalidate()
        }
    }

    func addPoint() {
        let currentTime = Date.now.formatted(date: .omitted, time: .standard)
        let yValue = Double(test[index])
        data.append((currentTime, yValue))
        index = (index + 1) % test.count
        
        // Fixed number of points in the chart
        if data.count > 10 {
            data.removeFirst()
        }
    }
}
/*
struct lmaoContentView_Previews: PreviewProvider {
    static var previews: some View {
        lmaoContentView()
    }
} */

