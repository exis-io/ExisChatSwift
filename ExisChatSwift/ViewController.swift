//
//  ViewController.swift
//  ExisChatSwift
//
//  Created by Chase Roossin on 4/4/16.
//  Copyright © 2016 Exis. All rights reserved.
//

import UIKit
import Riffle
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {

    var messages = [JSQMessage]()

    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var outgoingAvatar: JSQMessagesAvatarImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    var incomingAvatar: JSQMessagesAvatarImage!

    var locationManager: LocationManager?
    var currentLocation: CLLocation?

    var app: Domain!
    var me: Domain!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        //Set up your app
        //Change USERNAME to your username that you used to sign up with at my.exis.io
        app = Domain(name: "xs.demo.USERNAME.swiftchat")

        //Set up your domain
        me = Domain(name: "localagent", superdomain: app)

        //Joining container with your token
        //Copy from: Auth() -> Authorized Key Management -> 'localagent' key
//        me.setToken("XXXXXX")
        me.join()

        //Listen for people sending messages!
        app.subscribe("chat", gotMsg)
    }

    func gotMsg(message: String){
        displayMsg("backend", displayName: "Exis", text: message)
        finishReceivingMessage()
    }

    func displayMsg(id: String, displayName: String, text: String) {
        messages.append(JSQMessage(senderId: id, displayName: displayName, text: text))
    }

    private func setup() {
        //For Chat UI
        self.senderId = "localagent"
        self.senderDisplayName = "self"
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = bubbleImageFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = bubbleImageFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())

        outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "user"), diameter: UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width))
        incomingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "exis-logo"), diameter: UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width))

        //Change toolbar button
        let locationButton = UIButton(frame: CGRectZero)
        let locationImage = UIImage(named: "location")
        locationButton.setImage(locationImage, forState: UIControlState.Normal)
        self.inputToolbar.contentView.leftBarButtonItemWidth = CGFloat(20.0)
        self.inputToolbar.contentView.leftBarButtonItem = locationButton
    }


    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell

        let message = messages[indexPath.item]

        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.whiteColor()
        } else {
            cell.textView!.textColor = UIColor.blackColor()
        }

        return cell
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == "localagent"{ return outgoingAvatar }
        return incomingAvatar
    }

    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        app.publish("chat", text) //User sent - publish to Exis
        displayMsg(senderId, displayName: "Me", text: text)
        finishSendingMessage()
    }

    override func didPressAccessoryButton(sender: UIButton!) {
        //Location
        locationManager = LocationManager()
        locationManager!.fetchWithCompletion{location, error in
            if location != nil {
                self.currentLocation = location
                self.locationManager!.findUserCity(location!){ currCity in
                    let msg = "Hey! Anyone else out there from " + currCity! + "?"
                    self.app.publish("chat", msg)
                    self.displayMsg("localagent", displayName: "self", text: msg)
                    self.finishSendingMessage()
                }
            }
            else{
                print("Error getting location")
            }
        }
    }
}