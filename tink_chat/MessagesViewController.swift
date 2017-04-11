//
//  MessagesViewController.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 28.03.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    var messages = ["Hello", "Многие думают, что Lorem Ipsum - взятый с потолка псевдо-латинский набор слов, но это не совсем так. Его корни уходят в один фрагмент классической латыни 45 года н.э., то есть более двух тысячелетий назад. Ричард МакКлинток, профессор латыни из колледжа Hampden-Sydney, штат Вирджиния, взял одно из самых странных слов в Lorem Ipsum, consectetur, и занялся его поисками в классической латинской литературе. В результате он нашёл неоспоримый первоисточник Lorem Ipsum в разделах 1.10.32 и 1.10.33 книги de Finibus Bonorum et Malorum (О пределах добра и зла), написанной Цицероном в 45 году н.э. Этот трактат по теории этики был очень популярен в эпоху Возрождения. Первая строка Lorem Ipsum, Lorem ipsum dolor sit amet.., происходит от одной из строк в разделе 1.10.32",
                    "Что такое Lorem Ipsum? Lorem Ipsum - это текст-рыба, часто используемый в печати и вэб-дизайне. Lorem Ipsum является стандартной рыбой для текстов на латинице с начала XVI века. В то время некий безымянный печатник создал большую коллекцию размеров и форм шрифтов, используя Lorem Ipsum для распечатки образцов. Lorem Ipsum не только успешно пережил без заметных изменений пять веков, но и перешагнул в электронный дизайн. Его популяризации в новое время послужили публикация листов Letraset с образцами Lorem Ipsum в 60-х годах и, в более недавнее время, программы электронной вёрстки типа Aldus PageMaker, в шаблонах которых используется Lorem Ipsum. Почему он используется?Давно выяснено, что при оценке дизайна и композиции читаемый текст мешает сосредоточиться. Lorem Ipsum используют потому, что тот обеспечивает более или менее стандартное заполнение шаблона, а также реальное распределение букв и пробелов в абзацах, которое не получается при простой дубликации Здесь ваш текст.. Здесь ваш текст.. Здесь ваш текст.. Многие программы электронной вёрстки и редакторы HTML используют Lorem Ipsum в качестве текста по умолчанию, так что поиск по ключевым словам lorem ipsum сразу показывает, как много веб-страниц всё ещё дожидаются своего настоящего рождения. За прошедшие годы текст Lorem Ipsum получил много версий. Некоторые версии появились по ошибке, некоторые - намеренно (например, юмористические варианты). Откуда он появился?Многие думают, что Lorem Ipsum - взятый с потолка псевдо-латинский набор слов, но это не совсем так. Его корни уходят в один фрагмент классической латыни 45 года н.э., то есть более двух тысячелетий назад. Ричард МакКлинток, профессор латыни из колледжа Hampden-Sydney, штат Вирджиния, взял одно из самых странных слов в Lorem Ipsum, consectetur, и занялся его поисками в классической латинской литературе. В результате он нашёл неоспоримый первоисточник Lorem Ipsum в разделах 1.10.32 и 1.10.33 книги de Finibus Bonorum et Malorum (О пределах добра и зла), написанной Цицероном в 45 году н.э. Этот трактат по теории этики был очень популярен в эпоху Возрождения. Первая строка Lorem Ipsum, Lorem ipsum dolor sit amet.., происходит от одной из строк в разделе 1.10.32 ",
                    "Hello", "Многие думают, что Lorem Ipsum - взятый с потолка псевдо-латинский набор слов, но это не совсем так. Его корни уходят в один фрагмент классической латыни 45 года н.э., то есть более двух тысячелетий назад. Ричард МакКлинток, профессор латыни из колледжа Hampden-Sydney, штат Вирджиния, взял одно из самых странных слов в Lorem Ipsum, consectetur, и занялся его поисками в классической латинской литературе. В результате он нашёл неоспоримый первоисточник Lorem Ipsum в разделах 1.10.32 и 1.10.33 книги de Finibus Bonorum et Malorum (О пределах добра и зла), написанной Цицероном в 45 году н.э. Этот трактат по теории этики был очень популярен в эпоху Возрождения. Первая строка Lorem Ipsum, Lorem ipsum dolor sit amet.., происходит от одной из строк в разделе 1.10.32",
                    "Что такое Lorem Ipsum? Lorem Ipsum - это текст-рыба, часто используемый в печати и вэб-дизайне. Lorem Ipsum является стандартной рыбой для текстов на латинице с начала XVI века. В то время некий безымянный печатник создал большую коллекцию размеров и форм шрифтов, используя Lorem Ipsum для распечатки образцов. Lorem Ipsum не только успешно пережил без заметных изменений пять веков, но и перешагнул в электронный дизайн. Его популяризации в новое время послужили публикация листов Letraset с образцами Lorem Ipsum в 60-х годах и, в более недавнее время, программы электронной вёрстки типа Aldus PageMaker, в шаблонах которых используется Lorem Ipsum. Почему он используется?Давно выяснено, что при оценке дизайна и композиции читаемый текст мешает сосредоточиться. Lorem Ipsum используют потому, что тот обеспечивает более или менее стандартное заполнение шаблона, а также реальное распределение букв и пробелов в абзацах, которое не получается при простой дубликации Здесь ваш текст.. Здесь ваш текст.. Здесь ваш текст.. Многие программы электронной вёрстки и редакторы HTML используют Lorem Ipsum в качестве текста по умолчанию, так что поиск по ключевым словам lorem ipsum сразу показывает, как много веб-страниц всё ещё дожидаются своего настоящего рождения. За прошедшие годы текст Lorem Ipsum получил много версий. Некоторые версии появились по ошибке, некоторые - намеренно (например, юмористические варианты). Откуда он появился?Многие думают, что Lorem Ipsum - взятый с потолка псевдо-латинский набор слов, но это не совсем так. Его корни уходят в один фрагмент классической латыни 45 года н.э., то есть более двух тысячелетий назад. Ричард МакКлинток, профессор латыни из колледжа Hampden-Sydney, штат Вирджиния, взял одно из самых странных слов в Lorem Ipsum, consectetur, и занялся его поисками в классической латинской литературе. В результате он нашёл неоспоримый первоисточник Lorem Ipsum в разделах 1.10.32 и 1.10.33 книги de Finibus Bonorum et Malorum (О пределах добра и зла), написанной Цицероном в 45 году н.э. Этот трактат по теории этики был очень популярен в эпоху Возрождения. Первая строка Lorem Ipsum, Lorem ipsum dolor sit amet.., происходит от одной из строк в разделе 1.10.32 "]
    
    var messagesFromMe: [Int: String] = [:]
    var messagesToMe: [Int: String] = [:]
    
    var countMessages = 0
    
    var countToMe: Int = 0
    var countFromMe: Int = 0
    
    var delegate: SafeMessages?
    
    var history: Bool = true
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var multipeer: MultipeerCommunicator?
    
    var titleTo: String?
    
    var userID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        countMessages = messagesToMe.count + messagesFromMe.count
        self.table.dataSource = self
        self.table.rowHeight = UITableViewAutomaticDimension
        self.table.estimatedRowHeight = 44
        
        self.title = titleTo
        
        messages.removeAll()
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
            multipeer?.sendMessage(string: t, to: userID!, completionHandler: completeSend)
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
