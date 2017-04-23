import UIKit

protocol SafeMessages {
    func saveMessages(userID: String, fromMe: [Int:String], toMe: [Int:String])
}

class ConversationsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SafeMessages, IConversationsModelDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var onlineUsers: [String: IConversationCellConfiguration] = [:]
    var history: [String: IConversationCellConfiguration] = [:]
    
    var messagesToMe: [String: [Int:String]] = [:] //from 'key' to me
    var messagesFromMe: [String: [Int:String]] = [:] //from me to 'key'
    
    let conversationsModel = ConversationsModel()
    
    var userID: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        //данные для примера
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd.MM.yyyy HH:mm"
//        messages.append(CellData(n: "Leo", m: "Hello, watsup )))))))))))))))))))))))))))))))))))))))))))))heh", d: formatter.date(from: "20.03.2017 12:10")!, h: true, o: true))
//        messages.append(CellData(n: "Tom", m: "Hi", d: Date(), h: false, o: true))
//        messages.append(CellData(n: "Jerry", m: nil, d: Date(), h: false, o: false))
//        messages.append(CellData(n: "Kate", m: "No", d: Date(), h: false, o: false))
//        messages.append(CellData(n: "Niko", m: "Hello", d: formatter.date(from: "27.03.2017 12:10")!, h: true, o: false))
        
        conversationsModel.delegate = self
    }
    
    func addUser(name: String, ID: String, message: String?, date: Date = Date(), unread: Bool = false, online: Bool = true) {
        
        userID = ID
        if(history[ID] == nil) {
            onlineUsers[ID] = CellData(n: name, m: message, d: date, h: unread, o: online)
        } else {
            onlineUsers[ID] = history[ID]
            history.removeValue(forKey: ID)
        }
        
        onlineUsers[ID]?.online = true
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    func deleteUser(peerID: String) {
        if(onlineUsers[peerID] != nil) {
            history[peerID] = onlineUsers[peerID]
            history[peerID]?.online = false
            onlineUsers.removeValue(forKey: peerID)
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    func didRecieveMessage(text: String, userID: String) {
        if(onlineUsers[userID] != nil) {
            onlineUsers[userID]!.message = text
            onlineUsers[userID]!.hasUnreadMessages = true
            onlineUsers[userID]!.date = Date()
        } else {
            history[userID]?.message = text
            history[userID]?.hasUnreadMessages = true
            history[userID]?.date = Date()
        }
        //newMessages[userID]?.append(text)
        
        if let mTo = messagesToMe[userID] {
            if(!mTo.isEmpty){
                let lastKey = [Int](mTo.keys).last
                if let key = lastKey {
                    messagesToMe[userID] = [key + 1 : text]
                }
                
            } else {
                messagesToMe[userID] = [0 : text]
            }
            
        } else {
            messagesToMe[userID] = [0 : text]
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func saveMessages(userID: String, fromMe: [Int:String], toMe: [Int:String]) {
        messagesToMe[userID] = toMe
        messagesFromMe[userID] = fromMe
        
        onlineUsers[userID]?.hasUnreadMessages = false
        history[userID]?.hasUnreadMessages = false

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return onlineUsers.count
        } else {
            return history.count;
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "Online"
        } else {
            return "History"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "onlineID", for: indexPath) as? ConversationCell
        if let c = cell {
            var data: IConversationCellConfiguration
            if(indexPath.section == 0){
                data = ([IConversationCellConfiguration](onlineUsers.values))[indexPath.row]
            } else {
                data = ([IConversationCellConfiguration](history.values))[indexPath.row]
            }
            //let data = messages[indexPath.row]
            c.name = data.name
            c.message = data.message
            c.date = data.date
            c.online = data.online
            c.hasUnreadMessages = data.hasUnreadMessages
            return c
        }
        
        return cell!
    }
    
    
    var tapped: IndexPath?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tapped = indexPath
        self.performSegue(withIdentifier: "openChat", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toViewController = segue.destination as? MessagesViewController
        
        if let to = toViewController {
            if(tapped!.section == 0) {
                to.titleTo = [IConversationCellConfiguration](onlineUsers.values)[tapped!.row].name
                let id = [String](onlineUsers.keys)[tapped!.row]
                to.userID = id
                to.history = false
                if let mFrom = messagesFromMe[id]{
                    to.messagesFromMe = mFrom
                }
                if let mTo = messagesToMe[id] {
                    to.messagesToMe = mTo
                }
            } else {
                to.titleTo = [IConversationCellConfiguration](history.values)[tapped!.row].name
                let id = [String](history.keys)[tapped!.row]
                to.userID = id
                to.history = true
                if let mFrom = messagesFromMe[id]{
                    to.messagesFromMe = mFrom
                }
                if let mTo = messagesToMe[id] {
                    to.messagesToMe = mTo
                }
                
            }
            conversationsModel.prepare(for: to)
            to.delegate = self
        }
    }
    
}
