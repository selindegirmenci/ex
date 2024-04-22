

import SwiftUI
import Network
import FirebaseAuth

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    @Published var isActive = false
    @Published var isExpensive = false
    @Published var isConstrained = false
    @Published var connectionType = NWInterface.InterfaceType.other

    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isActive = path.status == .satisfied
                self.isExpensive = path.isExpensive
                self.isConstrained = path.isConstrained

                let connectionTypes: [NWInterface.InterfaceType] = [.cellular, .wifi, .wiredEthernet]
                self.connectionType = connectionTypes.first(where: path.usesInterfaceType) ?? .other
            }
        }
        monitor.start(queue: queue)
    }
}

class AuthenticationViewModel: ObservableObject {
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings Page")
            .navigationTitle("Go to Device Settings")
            .onAppear {
                openDeviceSettings()
            }
    }

    private func openDeviceSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(settingsURL)
    }
}

struct NetworkView: View {
    @StateObject var networkMonitor = NetworkMonitor()
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var selectedTab: String? // Track the selected tab
    @State private var shouldShowLoginView = false
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: NetworkStatusView(networkMonitor: networkMonitor), tag: "NetworkStatus", selection: $selectedTab) {
                    Label("Network Status", systemImage: "network")
                }
                NavigationLink(destination: SettingsView(), tag: "Settings", selection: $selectedTab) {
                    Label("Settings", systemImage: "gear")
                }
                Button(action: {
                    viewModel.signOut()
                    shouldShowLoginView = true
                }) {
                    Label("Sign Out", systemImage: "person.crop.circle.fill.badge.minus")
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Tools")
            .onAppear {
                selectedTab = "NetworkStatus" // Set the initial selected tab
            }
            .background(
                NavigationLink(
                    destination: LoginView(),
                    isActive: $shouldShowLoginView,
                    label: { EmptyView() }
                )
            )
        }
            
        }
    }

struct NetworkStatusView: View {
    @ObservedObject var networkMonitor: NetworkMonitor

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Network Status")
                .bold()
                .font(.title)

            HStack {
                Image(systemName: networkMonitor.isActive ? "wifi" : "wifi.slash")
                    .foregroundColor(networkMonitor.isActive ? .green : .red)
                Text(verbatim: "Connected: \(networkMonitor.isActive.description)")
            }
            HStack {
                Image(systemName: networkMonitor.isConstrained ? "antenna.radiowaves.left.and.right" : "antenna.radiowaves.left.and.right.slash")
                    .foregroundColor(networkMonitor.isConstrained ? .green : .red)
                Text(verbatim: "Low Data Mode: \(networkMonitor.isConstrained.description)")
            }
            HStack {
                Image(systemName: networkMonitor.isExpensive ? "bolt.horizontal" : "bolt.horizontal.circle")
                    .foregroundColor(networkMonitor.isExpensive ? .green : .red)
                Text(verbatim: "Mobile Data / Hotspot: \(networkMonitor.isExpensive.description)")
            }
            HStack {
                Image(systemName: "network")
                    .foregroundColor(.green) // Set a specific color
                Text(verbatim: "Type: \(networkMonitor.connectionType)")
            }
        }
    }
}

struct NetworkView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkView()
    }
}
