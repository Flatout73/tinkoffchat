//
//  Multipeer.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 10.04.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol Communicator {
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
    weak var delegate: CommunicatorDelegate? {get set}
    var online: Bool {get set}
}

class MultipeerCommunicator : NSObject, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate, Communicator {
    
    
    var online = false
    weak var delegate: CommunicatorDelegate?

    
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
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: ["userName" : "Leon"], serviceType: serviceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        
        super.init()
        
        print("init")
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
        
        //delegate?.didFoundUser(userID: peerID.displayName, userName: "kek")
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        
        invitationHandler(true, session)
        
        sessions[peerID.displayName] = session
        
//        let alert = UIAlertView(title:"Get invitation", message:nil, delegate:nil, cancelButtonTitle:"OK")
//        
//        alert.show()
        
        
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
        print(info)
        
//        let alert = UIAlertView(title:"Found", message:nil, delegate:nil, cancelButtonTitle:"OK")
//        
//        alert.show()
        
        if(sessions[peerID.displayName] == nil) {
            delegate?.didFoundUser(userID: peerID.displayName, userName: info?["userName"])
            let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
            session.delegate = self
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
            
            sessions[peerID.displayName] = session
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("didChange")
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("data")
        
        let res:String = String(data:data, encoding: .utf8)!
        
        print(res)
        do {
            let d = try JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
            print(d)
            delegate?.didReceiveMessage(text: d["text"]!, fromUser: peerID.displayName, toUser: myPeerId.displayName)
        } catch{
            print(error)
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
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        print("sendMessage")
        
        do {
        if let userSession = sessions[userID]{
    //возможно здесь нужно не создавать новый объект, а предворительно сохранять в словарь стринг-пирИД
            
            let message = "{\"eventType\":\"TextMessage\", \"messageId\":\"\(self.generateMessageId())\", \"text\": \"\(string)\"}"
            print(userSession.connectedPeers)
            try userSession.send(message.data(using: .utf8)!, toPeers: userSession.connectedPeers, with: .reliable)
        }
        } catch {
            print(error)
        }
    }
    
    func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX)) + \(Date.timeIntervalSinceReferenceDate) +\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        
        return string!
    }
    
}
