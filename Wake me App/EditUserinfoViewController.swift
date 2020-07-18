//
//  EditUserinfoViewController.swift
//  Wake me App
//
//  Created by 松田羽純 on 2020/03/10.
//  Copyright © 2020 松田羽純. All rights reserved.
//

import UIKit
import NCMB
import NYXImagesKit

class EditUserinfoViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var userIdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.delegate = self
        userIdTextField.delegate = self
        
//        let displayName = NCMBUser.current()?.object(forKey: "displayName")
        let userName = NCMBUser.current()?.userName
        userNameTextField.text = userName
        
        var userId = NCMBUser.current()?.object(forKey: "userId")
        if userId == nil{
            print("userIdはまだ設定されていません")
        }
        userIdTextField.text = userId as? String
    }
    
    // 画面閉じるコード
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func  textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
  
    @IBAction func saveUserInfo() {
        let user = NCMBUser.current()
        user?.setObject(userNameTextField.text, forKey: "userName")
        user?.setObject(userIdTextField.text, forKey: "userId")
        user?.saveInBackground({ (error) in
            if error != nil {
                let alert = UIAlertController(title: "送信エラー", message: error!.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func closedEditViewController(){
        self.dismiss(animated: true, completion: nil)
    }
}


