//
//  InterfaceController.swift
//  XSwatch Extension
//
//  Created by Chase Roossin on 4/16/16.
//  Copyright © 2016 Exis. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    var initialResponses = ["Exis rocks!", "How is it this easy??", "We <3 Exis!"]
    
    @IBAction func displayTextInput() {
        self.presentTextInputControllerWithSuggestions(initialResponses, allowedInputMode: WKTextInputMode.AllowEmoji) { (input: [AnyObject]?) in
            if input?.count != 0{
                //response given
                let response = input![0] as! String
                print(response)
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
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
