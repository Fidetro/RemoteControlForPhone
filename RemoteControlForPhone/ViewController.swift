//
//  ViewController.swift
//  RemoteControlForPhone
//
//  Created by Fidetro on itemSpace21/3/24.
//

import UIKit
import SnapKit

class KeyboardButton : UIButton {
    var keycode : String
     init(keycode: String) {
        self.keycode = keycode
        super.init(frame: .zero)
        self.setTitle(keycode, for: .normal)
        backgroundColor = .black
        setTitleColor(.white, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {

    let udpController = UDPController()
    
    lazy var broadcastBtn: UIButton = {
        var broadcastBtn = UIButton()
        broadcastBtn.setTitle("广播", for: .normal)
        broadcastBtn.setTitleColor(.black, for: .normal)
        broadcastBtn.addTarget(self, action: #selector(broadcastAction), for: .touchUpInside)
        return broadcastBtn
    }()
    
    lazy var leftBtn: KeyboardButton = {
        let button = KeyboardButton.init(keycode: "left")
        button.addTarget(self, action: #selector(clickKeyBoardAction(sender:)), for: .allEvents)
        return button
    }()
    
    lazy var rightBtn: KeyboardButton = {
        let button = KeyboardButton.init(keycode: "right")
        button.addTarget(self, action: #selector(clickKeyBoardAction(sender:)), for: .allEvents)
        return button
    }()
    
    lazy var downBtn: KeyboardButton = {
        let button = KeyboardButton.init(keycode: "down")
        button.addTarget(self, action: #selector(clickKeyBoardAction(sender:)), for: .allEvents)
        return button
    }()
    
    lazy var upBtn: KeyboardButton = {
        let button = KeyboardButton.init(keycode: "up")
        button.addTarget(self, action: #selector(clickKeyBoardAction(sender:)), for: .allEvents)
        return button
    }()
    
    lazy var xBtn: KeyboardButton = {
        let button = KeyboardButton.init(keycode: "x")
        button.addTarget(self, action: #selector(clickKeyBoardAction(sender:)), for: .allEvents)
        return button
    }()
    
    lazy var zBtn: KeyboardButton = {
        let button = KeyboardButton.init(keycode: "z")
        button.addTarget(self, action: #selector(clickKeyBoardAction(sender:)), for: .allEvents)
        return button
    }()
    
    lazy var sBtn: KeyboardButton = {
        let button = KeyboardButton.init(keycode: "s")
        button.addTarget(self, action: #selector(clickKeyBoardAction(sender:)), for: .allEvents)
        return button
    }()
    
    var isDelay = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(broadcastBtn)
        view.addSubview(upBtn)
        view.addSubview(leftBtn)
        view.addSubview(rightBtn)
        view.addSubview(downBtn)
        view.addSubview(xBtn)
        view.addSubview(zBtn)
        view.addSubview(sBtn)
        let itemSpace = 30
        let itemSize = CGSize.init(width: 80, height: 50)
        broadcastBtn.snp.makeConstraints{
            $0.left.equalToSuperview().offset(40)
            $0.top.equalToSuperview().offset(30)
        }
        downBtn.snp.makeConstraints{
            $0.right.equalTo(rightBtn.snp.left).offset(-itemSpace)
            $0.centerY.equalTo(rightBtn).offset(40)
            $0.size.equalTo(itemSize)
        }
        leftBtn.snp.makeConstraints{
            $0.centerY.equalTo(rightBtn)
            $0.right.equalTo(downBtn.snp.left).offset(-itemSpace)
            $0.size.equalTo(itemSize)
        }
        rightBtn.snp.makeConstraints{
            $0.right.equalToSuperview().offset(-60)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(itemSize)
        }
        upBtn.snp.makeConstraints{
            $0.right.equalTo(rightBtn.snp.left).offset(-itemSpace)
            $0.centerY.equalTo(rightBtn).offset(-40)
            $0.size.equalTo(itemSize)
        }
        zBtn.snp.makeConstraints{
            $0.left.equalToSuperview().offset(60)
            $0.centerY.equalToSuperview().offset(itemSpace)
            $0.size.equalTo(itemSize)
        }
        xBtn.snp.makeConstraints{
            $0.left.equalTo(zBtn.snp.right).offset(itemSpace)
            $0.centerY.equalTo(zBtn)
            $0.size.equalTo(itemSize)
        }
        sBtn.snp.makeConstraints{
            $0.left.equalToSuperview().offset(60)
            $0.centerY.equalToSuperview().offset(-itemSpace)
            $0.size.equalTo(itemSize)
        }
    }
    
    @objc func clickKeyBoardAction(sender: KeyboardButton) {
        if isDelay {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            self.isDelay = false
        })
        self.isDelay = true
        udpController.send(keycode: sender.keycode)
    }
    
    @objc func broadcastAction() {
        udpController.broadcast()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }


}

