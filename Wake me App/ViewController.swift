//
//  ViewController.swift
//  Wake me App
//
//  Created by 松田羽純 on 2020/03/04.
//  Copyright © 2020 松田羽純. All rights reserved.




import UIKit
import NCMB
import PKHUD
import Kingfisher

class ViewController:UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    // setTimeArrayって名前の配列です
    var setTimeArray = [Post]()
    var users = [User]()
    //①
    var blockUserIdArray = [String]()
    
    @IBOutlet var setTimeTableView: UITableView!
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        setTimeTableView.dataSource = self
        setTimeTableView.delegate = self
        
        // 現在時刻表示
        // カスタムセルの登録
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle.main)
        setTimeTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        // 不要な線消してくれる
        setTimeTableView.tableFooterView = UIView()
        
        // 引っ張って更新
        setRefreshControl()
        
        loadTimeline()
        
        getBlockUser()
        
        setTimeTableView.rowHeight = 100
        
        if let user = NCMBUser.current(){
            print("ok")
        } else {
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
            // ログイン状態の保持
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
        }
    }
    
    // テーブルビューに表示するデータの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setTimeArray.count
    }
    
    // TableViewに表示するデータの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // idをつけたcellの取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TimelineTableViewCell
        
        // 表示内容を決める
        let user = setTimeArray[indexPath.row].user
        // ユーザーID
        cell.userIdNameLabel.text = "@\(user.userId)"
        
        //　ユーザーの名前
        cell.userNameLabel.text = user.userName
        
        // ユーザー画像　⚠️投稿時の写真になってる？
        let file = NCMBFile.file(withName: user.objectId, data: nil) as! NCMBFile
        file.getDataInBackground { (data, error) in
            if error != nil {
                cell.userImageView.layer.cornerRadius = cell.userImageView.bounds.width / 2.0
                cell.userImageView.layer.masksToBounds = true
                cell.userImageView.backgroundColor = UIColor(displayP3Red: 93/255, green: 167/255, blue: 151/255, alpha: 1.0)
            } else {
                if data != nil {
                    let image = UIImage(data: data!)
                    cell.userImageView.image = image
                    cell.userImageView.layer.cornerRadius = cell.userImageView.bounds.width / 2.0
                    cell.userImageView.layer.masksToBounds = true
                }
            }
        }
        
        // アラーム時間表示 setTimeArrayはPost型、今必要なのはその中の”setTime”がほしい！かつString型！
        cell.setTimeLabel.text = (setTimeArray[indexPath.row].setTime)as? String
        let setTimeString: String?
        setTimeString = stringFromDate(date: setTimeArray[indexPath.row].setTime, format: "HH:mm")
        cell.setTimeLabel.text = setTimeString
        
        // ステータス表示
        let userStates = user.isGetUp
        if userStates as? Bool !=  false {
            cell.statesImageView.image = UIImage(named: "sun.max.fill")
        } else if userStates as? Bool != true {
            cell.statesImageView.image = UIImage(named: "greenMoon_50.png")
        } else {
            cell.statesImageView.image = nil
        }
        print("ユーザーステータス表示")
        print(user)
        print(userStates)
        
        // cellを返す
        return cell
    }
    
    //② この関数はviewWillAppearと、ブロックが選択される部分(※最後のtableviewのコードに記載あり)の二箇所で読み込む
    func getBlockUser() {
        
        let query = NCMBQuery(className: "Block")
        
        //includeKeyでBlockの子クラスである会員情報を持ってきている
        query?.includeKey("user")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                //エラーの処理
                print("getBlockUser読み込み失敗")
                print(error)
            } else {
                //ブロックされたユーザーのIDが含まれる + removeall()は初期化していて、データの重複を防いでいる
                self.blockUserIdArray.removeAll()
                for blockObject in result as! [NCMBObject] {
                    //この部分で①の配列にブロックユーザー情報が格納
                    self.blockUserIdArray.append(blockObject.object(forKey: "blockUserID") as! String)
                    
                }
                
            }
        })
        loadTimeline()
    }
    
    // Postクラスのデータの読み込み
    func loadTimeline(){
        // 読み込み
        let query1 = NCMBQuery(className: "Post")
        let query2 = NCMBQuery(className: "Post")
        
        
        // 今日・昨日のデータ
        let formatter = DateFormatter()
        let today = Date()
        formatter.dateFormat = "yyyy年MM月dd日"
        let todayString = formatter.string(from: today)
        let yesterday = today.addingTimeInterval(-60 * 60 * 24)
        let yesterdayString = formatter.string(from: yesterday)
        
        // ⚠️setDateの情報持ってくる
        // 検索
        query1?.whereKey("setDate", equalTo: todayString)
        query2?.whereKey("setDate", equalTo: yesterdayString)
        print("セット時間")
        print(todayString)
        print(yesterdayString)
        
        // query統合
        let query = NCMBQuery.orQuery(withSubqueries: [query1, query2])
        
        // 降順
        query?.order(byDescending: "setTime")
        // userの情報持ってくる
        query?.includeKey("user")
        
        // オブジェクトの取得
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                print("Postクラスのデータの読み込み")
                print(error)
                HUD.show(.error)
            } else {
                print(result)
                // 投稿を格納しておく配列を初期化（これをしないとreload時にappendで二重に追加されてしまう）
                self.setTimeArray = [Post]()
                for postObject in result as! [NCMBObject] {
                    
                    let user = postObject.object(forKey: "user") as! NCMBUser
                    
                    // 退会済みユーザーの投稿を避けるため、activeがfalse以外のモノだけを表示
                    if user.object(forKey: "active") as? Bool != false {
                        
                        // ==:同じ　!=:違う の意味
                        if user.userName == nil{
                            user.userName = "名前がありません"
                        }
                        
                        // 投稿したユーザーの情報をUserモデルにまとめる
                        let userModel = User(objectId: user.objectId, userName: user.userName, userId: user.object(forKey:"userId") as! String)
                        userModel.isGetUp = user.object(forKey: "isGetUp") as? Bool
                        // 投稿の情報を取得
                        
                        // 2つのデータ(設定アラーム時間と誰が投稿したか?)を合わせてPostクラスにセット
                        let setTime = postObject.object(forKey: "setTime") as! Date
                        let post = Post(objectId: postObject.objectId, user: userModel, setTime: setTime as! Date)
                        
                        //appendする時に、ブロックユーザーがnilであったらappendされるようにしている。
                        if self.blockUserIdArray.firstIndex(of: user.objectId) == nil{
                            // 配列に加える
                            self.setTimeArray.append(post)
                        }
                    }}}
            // 投稿のデータが揃ったらTableViewをリロード
            self.setTimeTableView.reloadData()
        })}
    
    
    //自分以外＝>報告・ブロックする
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if setTimeArray[indexPath.row].user.objectId != NCMBUser.current()?.objectId {
            let reportButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "報告") { (action, index) -> Void in
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let reportAction = UIAlertAction(title: "報告する", style: .destructive) { (action) in
                    // PKHUD用にする
                    HUD.show(.labeledSuccess(title: "この投稿を報告しました。ご協力ありがとうございました。", subtitle: nil))
                    //新たにクラス作る
                    let object = NCMBObject(className: "Report")
                    object?.setObject(self.setTimeArray[indexPath.row].objectId, forKey: "reportId")
                    object?.setObject(NCMBUser.current(), forKey: "user")
                    object?.saveInBackground({ (error) in
                        if error != nil {
                            HUD.show(.labeledError(title: "エラーです", subtitle: nil))
                        } else {
                            HUD.flash(.progress, delay: 2)
                            tableView.deselectRow(at: indexPath, animated: true)
                        }
                    })
                }
                let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                    alertController.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(reportAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                tableView.isEditing = false
            }
            // 緑
            reportButton.backgroundColor = UIColor(displayP3Red: 93/255, green: 167/255, blue: 151/255, alpha: 1.0)
            let blockButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "ブロック") { (action, index) -> Void in
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let blockAction = UIAlertAction(title: "ブロックする", style: .destructive) { (action) in
                    
                    HUD.show(.labeledSuccess(title: "このユーザーをブロックしました。", subtitle: nil))
                    
                    //新たにクラス作る
                    let object = NCMBObject(className: "Block")
                    object?.setObject(self.setTimeArray[indexPath.row].user.objectId, forKey: "blockUserID")
                    object?.setObject(NCMBUser.current(), forKey: "user")
                    object?.saveInBackground({ (error) in
                        if error != nil{
                            
                            HUD.show(.labeledError(title: "エラーです", subtitle: nil))
                            
                        } else {
                            HUD.flash(.progress, delay: 2)
                            tableView.deselectRow(at: indexPath, animated: true)
                            
                            //ここで③を読み込んでいる
                            self.getBlockUser()
                        }
                    })
                }
                let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                    alertController.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(blockAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                tableView.isEditing = false
            }
            // 濃いグレー
            blockButton.backgroundColor = UIColor(displayP3Red: 69/255, green: 69/255, blue: 69/255, alpha: 1.0)
            return[blockButton,reportButton]
        } else {
            let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
                // ⚠️
                let query = NCMBQuery(className: "Post")
                query?.getObjectInBackground(withId: self.setTimeArray[indexPath.row].objectId, block: { (post, error) in
                    if error != nil {
                        
                        HUD.flash(.labeledError(title: "エラーです", subtitle: nil), delay: 2)
                        
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "投稿を削除しますか？", message: nil, preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                                alertController.dismiss(animated: true, completion: nil)
                            }
                            let deleteAction = UIAlertAction(title: "削除", style: .default) { (action) in
                                post?.deleteInBackground({(error)in
                                    if error != nil{
                                        
                                        HUD.flash(.labeledError(title: "エラーです", subtitle: nil), delay: 2)
                                        
                                    } else {
                                        tableView.deselectRow(at: indexPath, animated: true)
                                        self.loadTimeline()
                                        //                                        self.setTimeTableView.reloadTimeline()
                                    }
                                })
                            }
                            alertController.addAction(cancelAction)
                            alertController.addAction(deleteAction)
                            self.present(alertController, animated: true,completion: nil)
                            tableView.isEditing = false
                        }
                        
                    }
                })
            }
            //色変更
            deleteButton.backgroundColor =  UIColor(displayP3Red: 93/255, green: 167/255, blue: 151/255, alpha: 1.0)
            return [deleteButton]
        }
    }
    
    // ⚠️＠objcつけるように推奨されたけどこれでいいのかな？
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        loadTimeline()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }}
    
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        setTimeTableView.addSubview(refreshControl)
    }
    
    
    func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    
    
    
}
