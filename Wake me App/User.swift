//
//  User.swift
//  Wake me App
//
//  Created by 松田羽純 on 2020/03/31.
//  Copyright © 2020 松田羽純. All rights reserved.
//

import UIKit
import NCMB

class User {
    var objectId: String
    var userName: String
    var userId: String
    var isGetUp: Bool?
    
    // ユーザーIDと名前は絶対ある
    init(objectId: String, userName: String, userId: String) {
        self.objectId = objectId
        self.userName = userName
        self.userId = userId
        
    }
    
}
