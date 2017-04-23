//
//  MessagesViewController.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 28.03.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, IMessagesModelDelegate {

    
    var messagesFromMe: [Int: String] = [:]
    var messagesToMe: [Int: String] = [:]
    
    var countMessages = 0
    
    var countToMe: Int = 0
    var countFromMe: Int = 0
    
    var delegate: SafeMessages?
    var history: Bool = true
    
    var messagesModel: MessagesModel?
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    //var multipeer: MultipeerCommunicator?
    
    var titleTo: String?
    
    var userID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        countMessages = messagesToMe.count + messagesFromMe.count
        self.table.dataSource = self
        self.table.rowHeight = UITableViewAutomaticDimension
        self.table.estimatedRowHeight = 44
        
        self.title = titleTo
        
        textBox.delegate = self
        
        if(history) {
            sendButton.isEnabled = false
        }
    }

    func didReceiveMessage(text: String) {
        //messages.append(text)
        
        messagesToMe[countMessages] = text
        countMessages += 1
        
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.saveMessages(userID: userID!, fromMe: messagesFromMe, toMe: messagesToMe)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return countMessages
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(messagesFromMe[indexPath.section] == nil){
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageID", for: indexPath) as? BubbleMessageCell
        if let c = cell {
            c.messageLabel.text = messagesToMe[indexPath.section]
            c.textM = messagesToMe[indexPath.section]
            return c
        } else {
            return cell!
            }
        }
        else {
         let cell = tableView.dequeueReusableCell(withIdentifier: "meMessageID", for: indexPath) as? BubbleMessageCell
            if let c = cell {
                c.messageLabel.text = messagesFromMe[indexPath.section]
                c.textM = messagesFromMe[indexPath.section]
                return c
            } else {
                return cell!
            }
        }
    }
    
    
    @IBAction func sendMessage(_ sender: UIButton) {
        
        if let t = textBox.text{
            //multipeer?.sendMessage(string: t, to: userID!, completionHandler: completeSend)
            if let id = userID {
                messagesModel?.send(message: t, to: id, completionHandler: completeSend)
            } else {
                print("No userID")
            }
        }
    }
    
    func completeSend(success: Bool, err: Error?) {
        if(success) {
            messagesFromMe[countMessages] = textBox.text
            countMessages += 1
            
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        } else {
            let alert = UIAlertView(title:"Ошибка при отправке сообщения", message:err?.localizedDescription, delegate:nil, cancelButtonTitle:"OK")
            
            alert.show()
            
            //sendButton.isEnabled = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textBox.resignFirstResponder()
        return true
    }
    
//    func updateTableContentInset() {
//        var numRows = tableView(table, numberOfRowsInSection: 0)
//        var contentInsetTop = self.table.bounds.size.height
//        for i in 0..<numRows {
//            contentInsetTop -= tableView(table, heightForRowAt: IndexPath(item: i, section: 0))
//            if contentInsetTop <= 0 {
//                contentInsetTop = 0
//            }
//        }
//        self.table.contentInset = UIEdgeInsetsMake(contentInsetTop, 0, 0, 0)
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
