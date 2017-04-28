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
    
    //это нужно для отображения в таблице
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
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)
    }
    
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
    
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion =  userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = (keyboardFrame.height) * (show ? 1 : -1)
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.bottomConstraint.constant += changeInHeight
        })
        
    }

    func didReceiveMessage(text: String) {
        //messages.append(text)
        
        messagesToMe[countMessages] = text
        countMessages += 1
        
        DispatchQueue.main.async { [weak self] in
            if let this = self{
                this.table.reloadData()
                this.table.scrollToRow(at: IndexPath(row: 0, section: this.countMessages - 1), at: .bottom, animated: true)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.saveMessages(userID: userID!, fromMe: messagesFromMe, toMe: messagesToMe)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
            if(t != ""){
                if let id = userID {
                    messagesModel?.send(message: t, to: id, completionHandler: completeSend)
                    textBox.text = ""
                } else {
                    print("No userID")
                }
            }
        }
    }
    
    func completeSend(success: Bool, err: Error?) {
        if(success) {
            messagesFromMe[countMessages] = textBox.text
            countMessages += 1
            
            DispatchQueue.main.async { [weak self] in
                if let this = self{
                    this.table.reloadData()
                    this.table.scrollToRow(at: IndexPath(row: 0, section: this.countMessages - 1), at: .bottom, animated: true)
                }
            }
        } else {
            let alert = UIAlertView(title:"Соединение потеряно", message:err?.localizedDescription, delegate:nil, cancelButtonTitle:"OK")
            
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
