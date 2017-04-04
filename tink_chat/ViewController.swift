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
    
    let gcd = GCDataManager()
    lazy var oper = OperationDataManager()
    
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
        
        didChanges(yes: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            avatar.image = (info[UIImagePickerControllerOriginalImage] as? UIImage?)!
            avatar.contentMode = UIViewContentMode.scaleAspectFill
            avatar.clipsToBounds = true
            
            dismiss(animated: true, completion: nil)
    }
    
    func selectorChanged() {
        didChanges(yes: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //print("\(#function)")
        
//        for subviews in view.subviews {
//            print(subviews.description)
//        }
        avatar.isUserInteractionEnabled = true
        nameTextField.delegate = self
        
        progress.hidesWhenStopped = true
        
        didChanges(yes: false)
        
        nameTextField.addTarget(self, action: #selector(selectorChanged), for: .editingChanged)
        aboutMe.delegate = self
        
        progress.startAnimating()
    
        
        //gcd.read(complete: completeRead)
        oper.readInfo(complete: completeRead)
        
    }
    
    func completeRead(_ name: String, _ text: String, _ avatar: UIImage, _ color: UIColor?) {
        self.nameTextField.text = name
        self.avatar.image = avatar
        self.aboutMe.text = text
        
        print(color?.toHexString())
        if let col = color {
            print(col.toHexString())
            self.colorText.textColor = col
        }
        
        self.progress.stopAnimating()
    }
    
    func didChanges(yes: Bool = true) {
        if(yes) {
            GCDButton.isEnabled = true
            OperationButton.isEnabled = true
            GCDButton.backgroundColor = UIColor.yellow
            OperationButton.backgroundColor = UIColor.yellow
        } else {
            GCDButton.isEnabled = false
            OperationButton.isEnabled = false
            GCDButton.backgroundColor = UIColor.gray
            OperationButton.backgroundColor = UIColor.gray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        didChanges(yes: true)
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
        
        progress.startAnimating()
        didChanges(yes:false)
    
        gcd.save(name: nameTextField.text!, text: aboutMe.text, avatar: avatar.image!, color: colorText.textColor, complete: completeSave)
        
        print(colorText.textColor.toHexString())
    }

    @IBAction func saveOperations(_ sender: UIButton) {
    
        oper.saveInfo(name: nameTextField.text!, text: aboutMe.text, avatar: avatar.image!, color: colorText.textColor, complete: completeSave)
    }
    
    func completeSave(error: String?) {
        
        self.progress.stopAnimating()
        
        if let err = error {
            
            let alert = UIAlertController(title: "Не удалось сохранить данные", message: err, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Повторить", style: .default) { [weak self]
                (ACTION) in
                if let this = self {
                //let gcd = GCDataManager()
                this.gcd.save(name: this.nameTextField.text!, text: this.aboutMe.text, avatar: this.avatar.image!, color: this.colorText.textColor, complete: this.completeSave)
                }
            })
            
            self.present(alert, animated: true, completion: nil)
        } else {
        
        self.didChanges(yes: false)
        
        let alert = UIAlertView(title:"Данные успешно сохранены", message:nil, delegate:nil, cancelButtonTitle:"OK")
        
        alert.show()
        }
    }
    
    @IBAction func changeColor(_ sender: UIButton) {
        colorText.textColor = sender.backgroundColor
        didChanges(yes: true)
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

