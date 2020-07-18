//
//  SettingViewController.swift
//  Wake me App
//
//  Created by 松田羽純 on 2020/04/12.
//  Copyright © 2020 松田羽純. All rights reserved.
//

import UIKit
import NCMB

class SettingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func toUserInfo(_ sender: Any) {
        self.performSegue(withIdentifier: "toEditUserInfo", sender: nil)
    }
    
    @IBAction func logOut() {
        let alertController = UIAlertController(title: "メニュー", message: "メニューを選択して下さい。", preferredStyle: .actionSheet)
        let signOutAction = UIAlertAction(title: "ログアウト", style: .default) { (action) in
            NCMBUser.logOutInBackground({ (error) in
                if error != nil {
                    // エラーがあった場合
                    print(error)
                } else {
                    // ログアウト成功
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    // 画面の切り替え
                    
                    // ログイン状態の保持
                    let ud = UserDefaults.standard
                    ud.set(true, forKey: "isLogin")
                    ud.synchronize()
                }
            })
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(signOutAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signOut(){
        let alertController = UIAlertController(title: "メニュー", message: "メニューを選択して下さい。", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "退会", style: .default) { (action) in
            let user = NCMBUser.current()
            // ここでいうuserは今ログインしているユーザー
            user?.deleteInBackground({ (error) in
                if error != nil {
                    print(error)
                } else {
                    // 退会成功なら"signIn"画面に移動
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    // ログイン状態の保持
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
            })
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func closedSettingViewController(){
           self.dismiss(animated: true, completion: nil)
       }
}
