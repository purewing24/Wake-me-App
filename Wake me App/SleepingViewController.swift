//
//  SleepingViewController.swift
//  Wake me App
//
//  Created by 松田羽純 on 2020/04/15.
//  Copyright © 2020 松田羽純. All rights reserved.
//

import UIKit
import NCMB

class SleepingViewController: UIViewController {


    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var setTimeLabel: UILabel!
    @IBOutlet var getUpSwitch :UISwitch!

    var timeInterval = TimeInterval()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUpSwitch.onTintColor = UIColor(displayP3Red: 93/255, green: 167/255, blue: 151/255, alpha: 1.0)
        
         Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SleepingViewController.currentTime), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SleepingViewController.currentDay), userInfo: nil, repeats: true)
    }
    
    // ⚠️できてない
    override func viewWillAppear(_ animated: Bool) {
        
//        let user = NCMBUser.current()
//
//        let formatter = DateFormatter()
//        let today = Date()
//        formatter.dateFormat = "yyyy年MM月dd日"
//        let todayString = formatter.string(from: today)
//        let tomorrow = today.addingTimeInterval(60 * 60 * 24)
//        let tomorrowString = formatter.string(from: tomorrow)
//
//
//        let query1 = NCMBQuery(className: "Post")
//        let query2 = NCMBQuery(className: "Post")
//        query1?.whereKey("setTime", equalTo: todayString)
//        query2?.whereKey("setTime", equalTo: tomorrowString)
//
//        let query12 = NCMBQuery.orQuery(withSubqueries: [query1!,query2!])
//
////        let query3 = NCMBQuery(className: "Post")
//        query12?.whereKey("user", equalTo: user)
//
//        query12?.findObjectsInBackground({(objects, error) in
//            if (error != nil){
//                // 検索失敗時の処理
//                print("セット時間表示失敗")
//                print(error)
//            }else{
//                // 検索成功時の処理
//                let setTimeString: String?
//                setTimeString = self.stringFromDate(date: NCMBObject(className: "Post").object(forKey: "setTime") as! Date, format: "HH:mm")
//                self.setTimeLabel.text = NCMBObject(className: "Post").object(forKey: "setTime") as! String
//            }
//        })

    }

    @objc func currentTime(){
       let date = Date()
        let formatter = DateFormatter()
        // システム設定に合わせる場合は”jm”
        formatter.setLocalizedDateFormatFromTemplate("Hm")
        print(formatter.string(from: date))
        timeLabel.text = formatter.string(from: date)
        
        print("update")
    }
    @objc func currentDay(){
//          let date = Date()
//           let formatter = DateFormatter()
//           // システム設定に合わせる場合は
//           formatter.setLocalizedDateFormatFromTemplate("yMMMdE")
//           print(formatter.string(from: date))
//           dateLabel.text = formatter.string(from: date)
//
        
       //現在の日付を取得
        let date:Date = Date()
                
        //日付のフォーマットを指定する。
        let format = DateFormatter()
        format.dateFormat = "M月d日 E"
                
        //日付をStringに変換する
        let todayDate = format.string(from: date)
         dateLabel.text = todayDate
        print(todayDate)
       }
    
    func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    @IBAction func getUpSwitch(_ sender: UISwitch) {
           let user = NCMBUser.current()
          
          if(sender.isOn) {
          // オンの場合の処理
            user?.setObject(true, forKey: "isGetUp")
            user?.saveInBackground({ (error) in
                if error != nil {
                   print(error)
                   // errorだよって言うアラート
                   let alert = UIAlertController(title: "おはようできません", message: error!.localizedDescription, preferredStyle: .alert)
                   let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                   })
                   alert.addAction(okAction)
                   self.present(alert, animated: true, completion: nil)
                } else {
                   // 記録したよって言うアラート表示
                   let alert = UIAlertController(title: "おはようございます", message: "二度寝はダメよ", preferredStyle: .alert)
                   let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                   })
                   alert.addAction(okAction)
                   self.present(alert, animated: true, completion: nil)
                }
            })
          } else {
           // オフの場合の処理
             user?.setObject(false, forKey: "isGetUp")
             user?.saveInBackground({ (error) in
               if error != nil {
                   print(error)

               } else {

               }
            })
          }
       }
    
       func loadUserData() {
           if let currentUser = NCMBUser.current() {
               
               if let switchBool = currentUser.object(forKey: "isGetUp") as? Bool {
                   print(switchBool)
                   self.getUpSwitch.setOn(switchBool, animated: false)
               } else {
                   print("a")
                   self.getUpSwitch.setOn(true, animated: false)
               }
               
               
           } else {
               //ログアウトのコードを書く
               // ログアウト成功　これ❓
               let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
               let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
               UIApplication.shared.keyWindow?.rootViewController = rootViewController
               // 画面の切り替え
               
               // ログイン状態の保持
               let ud = UserDefaults.standard
               ud.set(true, forKey: "isLogin")
               ud.synchronize()
               print("b")
           }
           
       }
       
    
    @IBAction func closeButoonWasPressed(_ sender: UIButton) {
        //前のViewControllerに戻る
        dismiss(animated: true, completion: nil)
    }

}
