//
//  UDPController.swift
//  RemoteControlForMac
//
//  Created by Fidetro on 2021/3/24.
//

import Foundation
import CocoaAsyncSocket
import SwiftTool
import Carbon
class UDPController : NSObject,GCDAsyncUdpSocketDelegate {
    
    
    var udpSocket : GCDAsyncUdpSocket!
    
    override init() {
        super.init()
        udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        do{
            try udpSocket.bind(toPort: 50317)
            try udpSocket.beginReceiving()
        }catch{
            debugPrintLog(error)
        }
    }
    
    func receiver(address: Data) {
        if let data = "ok".data(using: .utf8) {
            udpSocket.send(data, toAddress: address, withTimeout: -1, tag: 0)
        }
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        let ip = GCDAsyncUdpSocket.host(fromAddress: address)
        debugPrintLog(ip)
        guard let datastr = String(data: data, encoding: .utf8) else {
            return
        }
        debugPrintLog(datastr)
        if datastr == "test" {
            receiver(address: address)
        } else {
            if let keycode = map(keycode: datastr) {
                sendEvent(keycode: keycode)
            } else {
                debugPrintLog("没找到按键")
            }
        }
    }
    
    func map(keycode: String) -> CGKeyCode? {
        let dict = ["left":CGKeyCode(kVK_LeftArrow),
                    "right":CGKeyCode(kVK_RightArrow),
                    "down":CGKeyCode(kVK_DownArrow),
                    "up":CGKeyCode(kVK_UpArrow),
                    "x":CGKeyCode(kVK_ANSI_X),
                    "z":CGKeyCode(kVK_ANSI_Z),
                    "s":CGKeyCode(kVK_ANSI_S)]
        return dict[keycode]
    }
    
    func sendEvent(keycode: CGKeyCode) {
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        let cmdd = CGEvent(keyboardEventSource: src, virtualKey: keycode, keyDown: true)
        let cmdu = CGEvent(keyboardEventSource: src, virtualKey: keycode, keyDown: false)
//        cmdd?.flags = CGEventFlags.maskCommand;
        let loc = CGEventTapLocation.cghidEventTap
        cmdd?.post(tap: loc)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05, execute: {
            cmdu?.post(tap: loc)
        })
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        debugPrintLog("发送成功")
    }
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        debugPrintLog("发送失败")
        debugPrintLog(error)
    }
    
}
