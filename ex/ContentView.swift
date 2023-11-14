import SwiftUI
import GaugeKit
import SwiftUICharts
import AVFoundation
import Foundation

struct TankData {
    let temperatureValue: Int
    let pressureValue: Int
    let voltageValue: Int
    let fuelLevelValue: Int

    init(raw: [String]) {
        self.temperatureValue = Int(raw[0]) ?? 0
        self.pressureValue = Int(raw[1]) ?? 0
        self.voltageValue = Int(raw[2]) ?? 0
        self.fuelLevelValue = Int(raw[3]) ?? 0
    }
}

func cleanRows(file:String) -> String {
    var cleanFile = file
    cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
    cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
    return cleanFile
    
}

func loadCSVData() -> [TankData] {
    var csvToStruct = [TankData] ()
    
    //locate csv file
    guard let filePath = Bundle.main.path(forResource: "sampleValues", ofType: "csv") else {
        print("file not found")
        return []
    }
    
    var data = ""
    do {
        data = try String(contentsOfFile: filePath)
    } catch {
        print(error)
        return []
    }
    data = cleanRows(file: data)
    var rows = data.components(separatedBy: "\n")
    //remove header
    rows.removeFirst()
    
    //loop and slip row into columns
    for row in rows {
        let csvColumns = row.components(separatedBy: ",")
        if csvColumns.count == rows.first?.components(separatedBy: ",").count {
            let linesStruct = TankData.init(raw: csvColumns)
            csvToStruct.append(linesStruct)
        }
    }
    
    return csvToStruct
}

/*
func loadCSV(from csvName: String) -> [TankData]
{
    var csvToStruct = [TankData]()
    //find file
    guard let filePath = Bundle.main.path(forResource: csvName, ofType: "csv") else{return []}
    
    var data = ""
    do {
        data = try String(contentsOfFile: filePath)
    }
    catch {
        print(error)
        return []
    }
    var rows = data.components(separatedBy: "\n")
    
    let columnCount = rows.first?.components(separatedBy: ",").count
    rows.removeFirst()
    
    for row in rows {
        let csvColumns = row.components(separatedBy: ",")
        if csvColumns.count == columnCount {
            let TankDataStruct = TankData.init(raw: csvColumns)
            csvToStruct.append(TankDataStruct)
        }
        
    }
    
    return csvToStruct
}
 */



struct ContentView: View {
   // @State private var tankData = TankData(temperature: 25.0, pressure: 100.0)
    var tankdata = loadCSVData()
    var body: some View {
        TabView {
            TabItem(title: "Dashboard", systemImage: "house") {
                DashboardView()//tankData: $tankData)
            }
            
            TabItem(title: "Charts", systemImage: "chart.line.uptrend.xyaxis.circle.fill") {
                ChartView()
            }
            TabItem(title: "QR Scanner", systemImage: "qrcode.viewfinder") {
                ScannerView()
            }
            
            TabItem(title: "Documentation", systemImage: "doc.viewfinder") {
                DocumentView()
            }

        }
    }

}

struct TabItem<Content: View>: View {
    let title: String
    let systemImage: String
    let content: Content

    init(title: String, systemImage: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.systemImage = systemImage
        self.content = content()
    }

    var body: some View {
        content
            .tabItem {
                Label(title, systemImage: systemImage)
            }
    }
}

struct DashboardView: View {
    @State  var temperatureValue: Int = 0
    @State  var pressureValue: Int = 0
    @State  var voltageValue: Int = 0
    @State  var fuelLevelValue: Int = 0
    @State private var currentIndex = 0
    @State private var isDataReading = false
    var tankdata = loadCSVData()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text("Generator 5 SCADA Dashboard")
                .font(.title)
                .padding()
            Spacer()

            HStack {
                Spacer()
                VStack {
                    Text("Temperature Reading")
                    GaugeView(title: "", value: temperatureValue, colors: [.red, .orange, .yellow, .blue])
                        .padding()
                        .frame(width: 120, height: 120)

                    Text("Pressure")
                    GaugeView(title: "", value: pressureValue, colors: [.gray, .yellow, .purple, ])
                        .padding()
                        .frame(width: 120, height: 120)
                    Text("Voltage")
                    GaugeView(title: "", value: voltageValue, colors: [.red, .pink, .blue, .blue])
                        .padding()
                        .frame(width: 120, height: 120)

                    Text("Fuel Level")
                    GaugeView(title: "", value: fuelLevelValue, colors: [.red, .orange, .yellow, .green])
                        .padding()
                        .frame(width: 120, height: 120)
                }
                TankView()
                    .frame(width: 550, height: 550)
                Spacer()
                
                VStack {
                    Text("Power Status")
                    Toggle("", isOn: $isDataReading)
                        .padding()
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                }
                .padding()
                
            }
            Spacer()
        }
        .onReceive(timer) { _ in
            // Update temperature and pressure values from the loaded CSV data
                        if isDataReading && currentIndex < tankdata.count {
                            let data = tankdata[currentIndex]
                            temperatureValue = data.temperatureValue
                            pressureValue = data.pressureValue
                            voltageValue = data.voltageValue
                            fuelLevelValue = data.fuelLevelValue
                            currentIndex = (currentIndex + 1) % tankdata.count // Move to the next row, looping back to the beginning if it reaches the end
                        }
            else{ isDataReading = true}
        }
    }
}
/*
struct ChartView: View {
    @State  var temperatureValue: Int = 0
    @State  var pressureValue: Int = 0
    @State  var voltageValue: Int = 0
    @State  var fuelLevelValue: Int = 0
    @State private var currentIndex = 0
    var tankdata = loadCSVData()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("Generator 5 Charts")
                .font(.title)
                .padding()
            Spacer()

            HStack {
                Spacer()
                VStack {
                    Text("Temperature Reading")
                    GaugeView(title: "", value: temperatureValue, colors: [.red, .orange, .yellow, .blue])
                        .padding()
                        .frame(width: 120, height: 120)

                    Text("Pressure")
                    GaugeView(title: "", value: pressureValue, colors: [.gray, .yellow, .purple, ])
                        .padding()
                        .frame(width: 120, height: 120)
                    Text("Voltage")
                    GaugeView(title: "", value: voltageValue, colors: [.red, .pink, .blue, .blue])
                        .padding()
                        .frame(width: 120, height: 120)

                    Text("Fuel Level")
                    GaugeView(title: "", value: fuelLevelValue, colors: [.red, .orange, .yellow, .green])
                        .padding()
                        .frame(width: 120, height: 120)
                }
    /*
     HStack {
     Spacer() // Push the content to the left
     LineChartView(data: pressureValue, title: "Pressure")
     .frame(height: 200)
     .padding()
     LineChartView(data: [123,23,943,32,132,137,76,93,53], title: "Temperature")
     .frame(height: 200)
     Spacer() // Push the content to the right
     } */
    
} */


struct TankView: View {
    var body: some View {
            Image("DieselGen")
                .resizable()
                .padding()
                
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


