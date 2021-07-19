import Foundation
import Network


class NetworkConnectionMonitor {
    
    static let shared = NetworkConnectionMonitor()
    
    private var isNetworkConnected: Bool = false {
        didSet(newValue) {
            if newValue == true {
                let notificationName = NSNotification.Name("networkConnected")
                NotificationCenter.default.post(name: notificationName, object: nil)
            }
        }
    }

    private var monitor: NWPathMonitor!
    
    private init(){
    }
    
    // NWPathMonitor는 cancel하면 재사용 불가능
    private func configureMonitor() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.isNetworkConnected = true
                }
                
            } else {
                DispatchQueue.main.async {
                    self.isNetworkConnected = false
                }
            }
        }
    }
    
    func isConnected() -> Bool {
        return isNetworkConnected
    }
    
    func startMonitoring() {
        configureMonitor()
        monitor.start(queue: .global())
    }
    
    func cancelMonitoring() {
        monitor.cancel()
    }
}

