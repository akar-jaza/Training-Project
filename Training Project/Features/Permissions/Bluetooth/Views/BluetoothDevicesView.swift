import Foundation
import SwiftUI
import CoreBluetooth

struct BluetoothDevicesView: View {
    @StateObject var bleManager = BLEManager()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List(bleManager.peripherals) { peripheral in
                    HStack(spacing: 14) {
                        Image(systemName: "antenna.radiowaves.left.and.right")
                            .font(.system(size: 18, weight: .medium))
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.secondary)
                        
                        Text(peripheral.name)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text(String(peripheral.rssi))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            bleManager.connect(to: peripheral)
                        }) {
                            if bleManager.connectedPeripheralUUID == peripheral.id {
                                Text("Connected")
                                    .foregroundColor(.green)
                            } else {
                                Text("Connect")
                            }
                        }
                    }
                }
                .padding(.vertical, 20)
                .scrollContentBackground(.hidden)
                
                ScanControlBar(bleManager: bleManager)
                    .padding(.bottom, 8)
            }
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Bluetooth Devices")
        }
        .task {
            bleManager.startScanning()
        }
    }
}

struct ScanControlBar: View {
    @ObservedObject var bleManager: BLEManager
    @State var animating = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Start Scanning Button
            Button(action: {
                animating = true
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    bleManager.startScanning()
                    print(bleManager.isSwitchedon)
                }
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .font(.system(size: 15, weight: .semibold))
                        .symbolEffect(.variableColor.iterative, isActive: bleManager.isSwitchedon)
                    
                    Text(bleManager.isSwitchedon ? "Scanning" : "Start Scanning")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.9), Color.blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: Color.blue.opacity(0.25), radius: 10, x: 0, y: 5)
            }
            
            // Stop Scanning Button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    bleManager.stopScanning()
                    print(bleManager.isSwitchedon)
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 15, weight: .medium))
                    
                    Text("Stop Scanning")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
                .foregroundColor(.primary.opacity(0.8))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Capsule()
                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                )
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

#Preview {
    let mockManager = BLEManager()
    mockManager.peripherals = [
        Peripheral(id: UUID(), name: "Bluetooth Speaker", rssi: -55),
        Peripheral(id: UUID(), name: "Smart Watch", rssi: -72)
    ]
    
    return BluetoothDevicesView(bleManager: mockManager)
}
