//
//  UDPController.swift
//  RemoteControlForPhone
//
//  Created by Fidetro on 2021/3/24.
//

import UIKit
import CocoaAsyncSocket
import SwiftTool
class UDPController : NSObject,GCDAsyncUdpSocketDelegate {
    
    
    var broadcastSocket : GCDAsyncUdpSocket!
    
    var connectAddress : Data?
    
    override init() {
        super.init()
        broadcastSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        do{
            try broadcastSocket.bind(toPort: 50317)
            try broadcastSocket.enableBroadcast(true)
            try broadcastSocket.beginReceiving()
        }catch{
            debugPrintLog(error)
        }
    }
    
    func broadcast() {
        if let data = "test".data(using: .utf8) {
            broadcastSocket.send(data, toHost: "255.255.255.255", port: broadcastSocket.localPort(), withTimeout: -1, tag: 0)
        }
    }
    
    func send(keycode: String) {
        if let connectAddress = connectAddress {
            broadcastSocket.send(keycode.data(using: .utf8)!, toAddress: connectAddress, withTimeout: -1, tag: 0)
        }        
    }
    
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        let ip = GCDAsyncUdpSocket.host(fromAddress: address)
        guard ip?.contains(getWiFiAddress() ?? "") == false else {
            return
        }
        debugPrintLog(ip)
        connectAddress = address

    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        debugPrintLog("发送成功")
    }
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        debugPrintLog("发送失败")
        debugPrintLog(error)
    }
    
    
    func getWiFiAddress() -> String? {
        var address : String?

    // Get list of all interfaces on the local machine:
       var ifaddr : UnsafeMutablePointer<ifaddrs>?
       guard getifaddrs(&ifaddr) == 0 else { return nil }
       guard let firstAddr = ifaddr else { return nil }

       // For each interface ...
       for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
           let interface = ifptr.pointee

           // Check for IPv4 or IPv6 interface:
           let addrFamily = interface.ifa_addr.pointee.sa_family
           if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

               // Check interface name:
               let name = String(cString: interface.ifa_name)
               if  name == "en0" {

                   // Convert interface address to a human readable string:
                   var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                   getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                               &hostname, socklen_t(hostname.count),
                               nil, socklen_t(0), NI_NUMERICHOST)
                   address = String(cString: hostname)
               }
           }
       }
       freeifaddrs(ifaddr)

       return address
   }
}
