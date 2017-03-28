import UIKit

class ConversationsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var messages: [ConversationCellConfiguration] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        messages.append(CellData(n: "Leo", m: "Hello, watsup )))))))))))))))))))))))))))))))))))))))))))))heh", d: formatter.date(from: "20.03.2017 12:10")!, h: true, o: true))
        messages.append(CellData(n: "Tom", m: "Hi", d: Date(), h: false, o: true))
        messages.append(CellData(n: "Jerry", m: nil, d: Date(), h: false, o: false))
        messages.append(CellData(n: "Kate", m: "No", d: Date(), h: false, o: false))
        messages.append(CellData(n: "Niko", m: "Hello", d: formatter.date(from: "27.03.2017 12:10")!, h: true, o: false))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
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
            let data = messages[indexPath.row]
            c.name = data.name
            c.message = data.message
            c.date = data.date
            c.online = data.online
            c.hasUnreadMessages = data.hasUnreadMessages
            return c
        }
        
        return cell!
    }
    
    var tapped: Int?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tapped = indexPath.row
        self.performSegue(withIdentifier: "openChat", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toViewController = segue.destination as? MessagesViewController
        
        if let to = toViewController {
            to.titleTo = messages[tapped!].name
        }
    }
    
}
