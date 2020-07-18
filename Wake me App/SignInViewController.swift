//
//  SignInViewController.swift
//  Wake me App
//
//  Created by 松田羽純 on 2020/03/06.
//  Copyright © 2020 松田羽純. All rights reserved.
//

import UIKit
import NCMB
import PKHUD

class SignInViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        userIdTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    // 画面閉じるコード
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signIn() {
        
        NCMBUser.logInWithMailAddress(inBackground: emailTextField.text, password: passwordTextField.text, block: {(user, error) in
          if (error != nil) {
            HUD.flash(.labeledError(title: "ログインエラー", subtitle: "入力内容を\n確認してください"), delay: 2)
            print(error)
          } else {
            // ログイン成功
              let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
              let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
              UIApplication.shared.keyWindow?.rootViewController = rootViewController
              // 画面の切り替え
              // ログイン状態の保持
              let ud = UserDefaults.standard
              ud.set(true, forKey: "isLogin")
              ud.synchronize()
          }
        })}
    
    @IBAction func forgetPassword() {
        // 書いておく
    }
}
