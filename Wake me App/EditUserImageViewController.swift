//
//  EditUserImageViewController.swift
//  Wake me App
//
//  Created by 松田羽純 on 2020/04/11.
//  Copyright © 2020 松田羽純. All rights reserved.
//

import UIKit
import NCMB
import NYXImagesKit

class EditUserImageViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var userImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
     override func viewWillAppear(_ animated: Bool) {
                if let user = NCMBUser.current() {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           // 画像のサイズ自動調整
           let selectedImage = info[.originalImage] as! UIImage
           let resizedImage = selectedImage.scale(byFactor: 0.4)
           
           picker.dismiss(animated: true, completion: nil)
           
           // 画像のアップロード
           let data = resizedImage?.pngData()
        let file = NCMBFile.file(withName: NCMBUser.current()?.objectId, data: data) as! NCMBFile
           file.saveInBackground({ (error) in
               if error != nil{
                   print(error)
               } else {
                   self.userImageView.image = selectedImage
               }
           }) { (progress) in
               print(progress)
           }
       }

      @IBAction func selectImage(){
          let actionController = UIAlertController(title: "画像の選択", message: "選択して下さい", preferredStyle: .actionSheet)
          let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action) in
              if UIImagePickerController.isSourceTypeAvailable(.camera){
                  // カメラ起動
                  let picker = UIImagePickerController()
                  picker.sourceType = .camera
                  picker.delegate = self
                  self.present(picker, animated: true, completion: nil)
              } else {
                  print("この機種ではカメラが使用できません")
              }
          }
          let alertAction = UIAlertAction(title: "フォトライブラリ", style: .default) { (action) in
              if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                  // アルバム起動
                  let picker = UIImagePickerController()
                  picker.sourceType = .photoLibrary
                  picker.delegate = self
                  self.present(picker, animated: true, completion: nil)
              } else {
                  print("この機種ではフォトライブラリが使用できません。")
              }
              
          }
          let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
              // キャンセル
              actionController.dismiss(animated: true, completion: nil)
          }
          actionController.addAction(cameraAction)
          actionController.addAction(alertAction)
          actionController.addAction(cancelAction)
          self.present(actionController, animated: true, completion: nil)
      }
    
      @IBAction func closedEditViewController(){
          self.dismiss(animated: true, completion: nil)
      }

}
