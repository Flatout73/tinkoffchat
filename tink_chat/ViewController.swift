//
//  ViewController.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 06.03.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var colorText: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var aboutMe: UITextView!
    
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    @IBOutlet weak var GCDButton: UIButton!
    @IBOutlet weak var OperationButton: UIButton!
    
    let Name = "Name"
    let Text =  "Text"
    let Color = "Color"
    
    @IBAction func tapOnImsge(_ sender: Any) {
        
        let myActionSheet = UIAlertController(title: "Действие", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let add = UIAlertAction(title: "Добавить фото", style: UIAlertActionStyle.default) { (ACTION) in
            if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }
        
        let del = UIAlertAction(title: "Удалить", style: UIAlertActionStyle.destructive) { (ACTION) in
            self.avatar.image = #imageLiteral(resourceName: "no_photo")
        }
        
        let camera = UIAlertAction(title: "Сфотографировать", style: UIAlertActionStyle.default){
            (Action) in
            if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
                let cam = UIImagePickerController()
                cam.delegate = self
                cam.sourceType = .camera
                cam.allowsEditing = false
                self.present(cam, animated: true, completion: nil)
            }
            
        }

        
        myActionSheet.addAction(add)
        myActionSheet.addAction(camera)
        myActionSheet.addAction(del)
        
        self.present(myActionSheet, animated: true, completion: nil)
        
        didChanges()
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            avatar.image = (info[UIImagePickerControllerOriginalImage] as? UIImage?)!
            avatar.contentMode = UIViewContentMode.scaleAspectFill
            avatar.clipsToBounds = true
            
            dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("\(#function)")
        
        for subviews in view.subviews {
            print(subviews.description)
        }
        avatar.isUserInteractionEnabled = true
        nameTextField.delegate = self
        
        progress.hidesWhenStopped = true
        
        GCDButton.isEnabled = false
        OperationButton.isEnabled = false
        
        nameTextField.addTarget(self, action: #selector(didChanges), for: .editingChanged)
        aboutMe.delegate = self
        
        progress.startAnimating()
        
        let queue = DispatchQueue.global(qos: .utility)
        
        queue.async {
            
            var textName = ""
            if let plist = Plist(name: "data") {
                var dict = plist.getValuesInPlistFile()
                textName = dict?[self.Name] as! String
            }
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let filePath = documentsURL.appendingPathComponent("avatar.png").path
            var image: UIImage?
            if FileManager.default.fileExists(atPath: filePath) {
                image = UIImage(contentsOfFile: filePath)
            }
            
            DispatchQueue.main.async {
                self.nameTextField.text = textName
                self.avatar.image = image
                self.progress.stopAnimating()
            }
        }
    }
    
    func didChanges() {
        GCDButton.isEnabled = true
        OperationButton.isEnabled = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        didChanges()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("\(#function)")
        
        for subviews in view.subviews {
            print(subviews.description)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("\(#function)")
        
        for subviews in view.subviews {
            print(subviews.description)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("\(#function)")
        
        for subviews in view.subviews {
            print(subviews.description)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("\(#function)")
        
        for subviews in view.subviews {
            print(subviews.description)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        print("\(#function)")
        
        for subviews in view.subviews {
            print(subviews.description)
        }
    }
    
    func saveDate() {
        if let plist = Plist(name: "data") {
            let dict = plist.getMutablePlistFile()!
            dict[self.Name] = self.nameTextField.text
            dict[self.Text] = self.aboutMe.text
    
            do {
                try plist.addValuesToPlistFile(dictionary: dict)
            } catch {
                print(error)
            }
            print(plist.getValuesInPlistFile()!)
        }
        else {
            print("Unable to get Plist")
        }
    
        do {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("avatar.png")
            if let pngImageData = UIImagePNGRepresentation(self.avatar.image!) {
                try pngImageData.write(to: fileURL, options: .atomic)
            }
        } catch {
            print(error)
        }
    }

    @IBAction func save(_ sender: UIButton) {
        //print("Сохранение данных профиля")
//        let file = "save.plist"
//        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//            let path = dir.appendingPathComponent(file)
//            //let fileManager = FileManager.default
//            var data: NSMutableDictionary = NSMutableDictionary(contentsOfFile: path)
//            data.set
//        }
        
        let queue = DispatchQueue.global(qos: .utility)
        
        progress.startAnimating()
        GCDButton.isEnabled = false
        OperationButton.isEnabled = false
        queue.async {
            self.saveDate()
            DispatchQueue.main.async {
                self.progress.stopAnimating()
                self.GCDButton.isEnabled = true
                self.OperationButton.isEnabled = true
            }
        }
    }

    @IBAction func saveOperations(_ sender: UIButton) {
        
    }
    @IBAction func changeColor(_ sender: UIButton) {
        colorText.textColor = sender.backgroundColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
        
    }
    
    @IBAction func closeView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

