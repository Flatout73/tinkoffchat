//
//  Multipeer.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 10.04.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerCommunicator : NSObject, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate, ICommunicator {
    
    
    var online = false
    weak var delegate: ICommunicatorDelegate?

    var myName = "Leon"
    
    private let serviceType = "tinkoff-chat"
    
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser
    
//    lazy var session: MCSession = {
//        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
//        session.delegate = self
//        
//        return session
//    }()
    
    var sessions = [String: MCSession]()
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: ["userName" : myName], serviceType: serviceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        
        super.init()
        
        print("init")
        sessions.removeAll()
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("didNotStartAdvertisingPeer")
        delegate?.failedToStartAdvertising(error: error)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        if(sessions[peerID.displayName] == nil) {
            var userName: String?
            do{
                if let c = context{
                    userName = (try JSONSerialization.jsonObject(with: c, options: []) as! [String: String])["userName"]
                }
            } catch{
                print(error)
            }
            delegate?.didFoundUser(userID: peerID.displayName, userName: userName)
            let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
            session.delegate = self
            
            invitationHandler(true, session)
            
            sessions[peerID.displayName] = session
            
        }
    }
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lost")
        delegate?.didLostUser(userID: peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("didNotStartingBrowsingForPeers")
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("found")
        print(info as Any)
        
        if(sessions[peerID.displayName] == nil && peerID.displayName != myPeerId.displayName) {
            delegate?.didFoundUser(userID: peerID.displayName, userName: info?["userName"])
            let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
            session.delegate = self
            let context = "{\"userName\": \"\(myName)\"}"
            browser.invitePeer(peerID, to: session, withContext: context.data(using: .utf8), timeout: 30)
            
            sessions[peerID.displayName] = session
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if(state == .notConnected) {
            print("Sessions lost")
            sessions[peerID.displayName] = nil
            delegate?.didLostUser(userID: peerID.displayName)
            
            session.cancelConnectPeer(peerID)
        } else if(state == .connected) {
            //sessions[peerID.displayName] = session
            print("Found again!")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("data")
        
        let res:String = String(data:data, encoding: .utf8)!
        
        print(res)
        let ser = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
        if let d = ser{
            if let message = d["text"]{
                if let messageId = d["messageId"] {
                    delegate?.didReceiveMessage(text: message, fromUser: peerID.displayName, toUser: myPeerId.displayName, messageID: messageId)
                } else {
                    print("Нет Id у сообщения")
                }
            } else {
                print("Нет поля text!")
            }
        } else {
            print("Ошибка при чтении сообщения")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("didStartReceivingResourceWithName")
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        print("didStartFinishResourceWithName")
    }
    
    func sendMessage(string: String, to userID: String, completionHandler: ((String?, Error?) -> ())?) {
        print("sendMessage to " + userID)
        
        do {
        if let userSession = sessions[userID]{
            
            let messageID = self.generateMessageId()
            let message = "{\"eventType\":\"TextMessage\", \"messageId\":\"\(messageID)\", \"text\": \"\(string)\"}"
            print(userSession.connectedPeers)
            try userSession.send(message.data(using: .utf8)!, toPeers: userSession.connectedPeers, with: .reliable)
        
            completionHandler?(messageID, nil)
        
        }
        } catch {
            completionHandler?(nil, error)
            print(error)
        }
    }
    
    func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX)) + \(Date.timeIntervalSinceReferenceDate) +\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        
        return string!
    }
    
}
