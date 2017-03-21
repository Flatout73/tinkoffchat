//
//  ViewController.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 06.03.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var colorText: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var avatar: UIImageView!
    
    @IBAction func tapOnImsge(_ sender: Any) {
        
        var myActionSheet = UIAlertController(title: "Действие", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
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

    @IBAction func save(_ sender: UIButton) {
        print("Сохранение данных профиля")
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
    
}

