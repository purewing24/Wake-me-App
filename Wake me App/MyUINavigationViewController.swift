//
//  MyUINavigationViewController.swift
//  Wake me App
//
//  Created by 松田羽純 on 2020/04/15.
//  Copyright © 2020 松田羽純. All rights reserved.
//

import UIKit

class MyUINavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let customGreen =
        //　ナビゲーションバーの背景色(緑)
        navigationBar.barTintColor = UIColor(displayP3Red: 93/255, green: 167/255, blue: 151/255, alpha: 1.0)
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
