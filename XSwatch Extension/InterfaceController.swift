//
//  InterfaceController.swift
//  XSwatch Extension
//
//  Created by Chase Roossin on 4/16/16.
//  Copyright © 2016 Exis. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    var initialResponses = ["Exis rocks!", "How is it this easy??", "We <3 Exis!"]
    var session: WCSession? = nil

    @IBAction func displayTextInput() {
        self.presentTextInputControllerWithSuggestions(initialResponses, allowedInputMode: WKTextInputMode.AllowEmoji) { (input: [AnyObject]?) in
            if input?.count != 0{
                //response given
                let response = input![0] as! String
                self.session?.sendMessage(["msg": response], replyHandler: { (responses) -> Void in
                    print(responses)
                }) { (err) -> Void in
                    print(err)
                }
            }else{
                print("No text given")
            }
        }
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
    }

    override func willActivate() {
        super.willActivate()
        if WCSession.isSupported() {
            self.session = WCSession.defaultSession()
            self.session!.delegate = self
            self.session!.activateSession()
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
