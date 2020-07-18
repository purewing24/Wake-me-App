//
//  UserPageViewController.swift
//  Wake me App
//
//  Created by 松田羽純 on 2020/03/06.
//  Copyright © 2020 松田羽純. All rights reserved.
//

import UIKit
import NYXImagesKit
import NCMB
import UITextView_Placeholder
import PKHUD

class UserPageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {
    
    
    @IBOutlet var setTimePicker: UIDatePicker!
    @IBOutlet var setDatePicker: UIDatePicker!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var toEditUserBarButtonItem: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
        
        setTimePicker.setDate(Date(), animated: false)
        
        print(setTimePicker.date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
            if let user = NCMBUser.current() {
                        userNameLabel.text = user.object(forKey: "userName") as? String
                
                if user.object(forKey: "userId") != nil {
                    userIdLabel.text = "@\(user.object(forKey: "userId")as! String)"
                } else {
                    userIdLabel.text = "@ユーザーIDを設定して下さい"
                }
                       
                 let file = NCMBFile.file(withName: user.objectId, data: nil) as! NCMBFile
                
                       file.getDataInBackground { (data, error) in
                           if error != nil {
                               let alert = UIAlertController(title: "画像取得エラー", message: error!.localizedDescription, preferredStyle: .alert)
                               let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                   
                               })
                               alert.addAction(okAction)
                               self.present(alert, animated: true, completion: nil)
                           } else {
                               if data != nil {
                                   let image = UIImage(data: data!)
                                   self.userImageView.image = image
                               }
                           }
                       }
                   } else {
                       // NCMBUser.current()がnilだったとき
                       let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                       let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                       UIApplication.shared.keyWindow?.rootViewController = rootViewController
                       
                       // ログイン状態の保持
                       let ud = UserDefaults.standard
                       ud.set(false, forKey: "isLogin")
                       ud.synchronize()
                   }
      }
    
    
    @IBAction func set() {
        let postObject = NCMBObject(className: "Post")
        let user = NCMBUser.current()

        // 日付の設定
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let setDate = formatter.string(from: setDatePicker.date)

        postObject?.setObject(setTimePicker.date, forKey: "setTime")
        postObject?.setObject(setDate, forKey: "setDate")
        postObject?.setObject(NCMBUser.current(), forKey: "user")

        print(NCMBUser.current())
        print(setTimePicker.date)
        
        postObject?.saveInBackground({ (error) in
            if error != nil {
                print(error)
                //errorだよって言うアラート
                let alertController = UIAlertController(title: "セットできません", message: error!.localizedDescription, preferredStyle: .actionSheet)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                // 記録したよって言うアラート表示
                let alertController = UIAlertController(title: "セット完了", message: "セット時間がタイムライン共有されます", preferredStyle: .alert)
//                let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
//
//                    // 画面閉じる
//                    alertController.dismiss(animated: true, completion: nil)
//                }
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                    
                    // ステータスを睡眠状態にする
                    user?.setObject(false, forKey: "isGetUp")
                    //アラートが消えるのと画面遷移が重ならないように0.5秒後に画面遷移するようにしてる
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        // sleepingVCに移動
                        //同じstororyboard内であることをここで定義
                        let storyboard: UIStoryboard = self.storyboard!
                        //移動先のstoryboardを選択
                        let toSleeping = storyboard.instantiateViewController(withIdentifier: "SleepingViewController")as! SleepingViewController
                        //実際に移動するコード
                        self.present(toSleeping, animated: true, completion: nil)
                    }
                })
                
               alertController.addAction(okAction)
//            alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        })

    }
    
}




