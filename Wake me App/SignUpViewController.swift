//
//  SignUpViewController.swift
//  Wake me App
//
//  Created by 松田羽純 on 2020/03/06.
//  Copyright © 2020 松田羽純. All rights reserved.
//

import UIKit
import NCMB

class SignUpViewController: UIViewController, UITextFieldDelegate {

//    @IBOutlet var userNameTextField: UITextField!
//    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
//    @IBOutlet var passwordTextField: UITextField!
//    @IBOutlet var confirmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        userNameTextField.delegate = self
//        userIdTextField.delegate = self
        emailTextField.delegate = self
//        passwordTextField.delegate = self
//        confirmTextField.delegate = self
       
    }
    
    // TextFieldを閉じるコード
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signUp() {
//        let user = NCMBUser()
        
//        if userIdTextField.text!.count < 4 {
//            print("文字数が足りません")
//            return
//        }
//
//        user.userName = userNameTextField.text!
//        print(user.userName)
//
//
//        var userId = user.object(forKey: "userId")
//        userId = userIdTextField.text!
//        user.setObject(userIdTextField.text, forKey: "userId")
//        print(userId)
//
        
//        user.mailAddress = emailTextField.text!
        // string(文字)を入れるために！（アンラップ）
        
//        if passwordTextField.text == confirmTextField.text {
//            user.password = passwordTextField.text!
//        } else {
//            print("パスワードの不一致")
//        }
        
        // メール認証
        var error : NSError? = nil
        NCMBUser.requestAuthenticationMail(emailTextField.text, error: &error)
        if (error != nil) {
          print(error ?? "")
        }
        print("メール完了")
        self.dismiss(animated: true, completion: nil)
        print("dismiss完了")
        }
        
//        user.signUpInBackground{ (error) in
//            if error != nil {
//                // エラーがあった場合
//                print("新規会員登録")
//                print(error)
//            } else {
//                // 登録成功
//                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//                let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
//                UIApplication.shared.keyWindow?.rootViewController = rootViewController
//                // 画面の切り替え
//
//                // ログイン状態の保持
//                let ud = UserDefaults.standard
//                ud.set(true, forKey: "isLogin")
//                ud.synchronize()
//            }
//        }
    }
