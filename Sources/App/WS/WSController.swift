//
//  WSController.swift
//  WS
//
//  Created by Mihael Isaev on 22/12/2018.
//

import Foundation
import WS

class WSController: WSBindController {
    override init() {
        super.init()
        bind(.message, message)
    }
    
    override func onOpen(_ client: WSClient) {}
    override func onClose(_ client: WSClient) {}
}
