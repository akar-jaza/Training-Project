// MARK: Source: https://youtu.be/dKUgxZC1y6Q?si=30F1-oT8XKkGRlXz

import Foundation
import SwiftUI
import CoreBluetooth
import Combine


class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var myCentral: CBCentralManager? // Central Manager
    @Published var isSwitchedon = false // A published variable to track if Bluetooth is switched on
    @Published var peripherals = [Peripheral]() // Declare a published array to store discovered peripherals
    @Published var connectedPeripheralUUID: UUID? // A published variable to store the UUID of the connected Peripheral
    
    init(myCentral: CBCentralManager? = nil) {
        super.init()
        if let passedCentral = myCentral {
            self.myCentral = passedCentral
            self.myCentral?.delegate = self
        } else {
            self.myCentral = CBCentralManager(delegate: self, queue: nil)
        }
    }
    
    // refresh status of BLE
    func refreshStatus() {
        isSwitchedon = myCentral?.state == .poweredOn
    }
    
    // Delegate method called when the state of the central manager is updated
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        isSwitchedon = central.state == .poweredOn // Update isSwitchedon based on the central's state
        
        if isSwitchedon {
            startScanning()
        } else {
            stopScanning()
        }
    }
    
    // Delegate method called when a peripheral is discovered
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let newPeripheral = Peripheral(id: peripheral.identifier, name: peripheral.name ?? "Unknown", rssi: RSSI.intValue) // Create a new Peripheral object
        if !peripherals.contains(where: { $0.id == newPeripheral.id }) { // Check if the peripheral is already in the list
            DispatchQueue.main.async {
                self.peripherals.append(newPeripheral) // Append the new peripheral to the list
            }
        }
    }
    
    // Function to start scanning for peripherals
    func startScanning() {
        guard let myCentral = myCentral else {
            print("startScanning failed: myCentral is nil")
            return
        }
        print("startScanning") // Print a message to the console
        myCentral.scanForPeripherals(withServices: nil, options: nil) // Start scanning with no specific services
    }
    
    // Function to stop scanning for peripherals
    func stopScanning() {
        guard let myCentral = myCentral else {
            print("startScanning failed: myCentral is nil")
            return
        }
        print("stopScanning") // Print a message to the console
        myCentral.stopScan() // Stop scanning
    }
    
    // Function to connect to a peripheral
    func connect(to peripheral: Peripheral) {
        guard let myCentral = myCentral else {
            print("startScanning failed: myCentral is nil")
            return
        }
        
        guard let cbPeripheral = myCentral.retrievePeripherals(withIdentifiers: [peripheral.id]).first
                else { // Retrieve the peripheral by its identifier
            print("Peripheral not found for connection") // Print a message if the peripheral is not found
            return // Return if the peripheral is not found
        }
        
        connectedPeripheralUUID = cbPeripheral.identifier // Set the connected peripheral's UUID
        cbPeripheral.delegate = self // Set self as the delegate of the peripheral
        myCentral.connect(cbPeripheral, options: nil) // Connect to the peripheral
    }
    
    // Delegate method called when a peripheral is connected
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Unknown")") // Print a message to the console
        peripheral.discoverServices(nil) // Discover services on the connected peripheral
    }
    
    // Delegate method called when the connection to a peripheral fails
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral.name ?? "Unknown"): \(error?.localizedDescription ?? "No error information")") // Print a message to the console
        if peripheral.identifier == connectedPeripheralUUID { // Check if the failed peripheral is the connected one
            connectedPeripheralUUID = nil // Clear the connected peripheral UUID
        }
    }
    
    // Delegate method called when a peripheral is disconnected
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from \(peripheral.name ?? "Unknown")") // Print a message to the console
        if peripheral.identifier == connectedPeripheralUUID { // Check if the disconnected peripheral is the connected one
            connectedPeripheralUUID = nil // Clear the connected peripheral UUID
        }
    }
}
