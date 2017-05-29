import UIKit
import CoreData

protocol SafeMessages {
    func saveMessages(userID: String, fromMe: [Int:String], toMe: [Int:String])
}

class ConversationsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SafeMessages, IConversationsModelDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var onlineUsers: [String: IConversationCellConfiguration] = [:]
    var history: [String: IConversationCellConfiguration] = [:]
    
    var messagesToMe: [String: [Int:String]] = [:] //from 'key' to me
    var messagesFromMe: [String: [Int:String]] = [:] //from me to 'key'
    
    var conversationsModel: ConversationsModel!
    
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
        conversationsModel = ConversationsModel(tableView: tableView, viewController: self)
        
        conversationsModel.frc.delegate = self
        
        conversationsModel.store.makeAllOffline()
        //conversationsModel.delegate = self
        
        do {
            try conversationsModel.frc.performFetch()
        } catch {
            print(error)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //conversationsModel.deleteUser(peerID: "121")
    }
    
    //для тестов
    var k = 121
    @IBAction func createUser(_ sender: Any) {
        conversationsModel.addUser(name: "Leo", ID: String(k))
        k += 1
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
                    messagesToMe[userID]?[key + 1] =  text
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
        //return 2
        
        return (conversationsModel.frc.sections?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(section == 0) {
//            return onlineUsers.count
//        } else {
//            return history.count;
//        }
        
        if(!conversationsModel.frc.sections!.isEmpty) {
        if let sectionInfo = conversationsModel.frc.sections?[section]{
            return sectionInfo.numberOfObjects
        } else { print("Unexpected Section") }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return conversationsModel.frc.sections?[section].indexTitle
//        if(section == 0) {
//            return "Online"
//        } else {
//            return "History"
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "onlineID", for: indexPath) as? ConversationCell
//        if let c = cell {
//            var data: IConversationCellConfiguration
//            if(indexPath.section == 0){
//                data = ([IConversationCellConfiguration](onlineUsers.values))[indexPath.row]
//            } else {
//                data = ([IConversationCellConfiguration](history.values))[indexPath.row]
//            }
//            //let data = messages[indexPath.row]
//            c.name = data.name
//            c.message = data.message
//            c.date = data.date
//            c.online = data.online
//            c.hasUnreadMessages = data.hasUnreadMessages
//            return c
//        }
//        
//        return cell!
        
        if let c = cell {
            let conversation = conversationsModel.frc.object(at: indexPath)
            
            if let participants = conversation.participants as? Set<User> {
                for user in participants{
                    c.name = user.name
                    break
                }
            }
            //c.name = (conversation.participants?.array.first as! User).name
            if let last = conversation.lastMessage{
                c.date = last.date as Date?
            } else {
                c.date = Date()
            }
            c.online = conversation.isOnline
            c.hasUnreadMessages = conversation.unreadMessages?.count != 0
            c.message = conversation.lastMessage?.text
            return c
        }
        
        return cell!
    }
    
    
    var tapped: IndexPath?
    var titleTo: String?
    var id: String?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tapped = indexPath
        
        
   
        let conversation = conversationsModel.frc.object(at: indexPath)
        var user: User?  //conversation.participants?.array.first as! User
        if let users = conversation.participants as? Set<User> {
            for us in users {
                user = us
                break
            }
        }
        titleTo = user?.name
        id = user?.userId
        
        self.performSegue(withIdentifier: "openChat", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toViewController = segue.destination as? MessagesViewController
        
        if let to = toViewController {
            var peerID: String
            if(tapped!.section == 0) {
                //to.titleTo = [IConversationCellConfiguration](onlineUsers.values)[tapped!.row].name
                to.titleTo = titleTo
                //let id = [String](onlineUsers.keys)[tapped!.row]
                peerID = id!
                to.userID = id
                to.history = false
//                if let mFrom = messagesFromMe[id]{
//                    to.messagesFromMe = mFrom
//                }
//                if let mTo = messagesToMe[id!] {
//                    to.messagesToMe = mTo
//                }
            } else {
                //to.titleTo = [IConversationCellConfiguration](history.values)[tapped!.row].name
                to.titleTo = titleTo
                //let id = [String](history.keys)[tapped!.row]
                peerID = id!
                to.userID = id
                to.history = true
//                if let mFrom = messagesFromMe[id]{
//                    to.messagesFromMe = mFrom
//                }
//                if let mTo = messagesToMe[id] {
//                    to.messagesToMe = mTo
//                }
                
            }
            conversationsModel.prepare(for: to, peerID: peerID)
            to.delegate = self
        } else {
        
            let toController = segue.destination as! UINavigationController
            let profileController = toController.visibleViewController
            conversationsModel.prepare(for: profileController as! ProfileViewController)
        }
    }
}

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex),
                                     with: .automatic)
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex),
                                     with: .bottom)
        case .move, .update: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        if(sectionName == "0") {
            return "History"
        } else {
            return "Online"
        }
    }
}
