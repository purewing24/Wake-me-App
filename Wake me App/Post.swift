//
//  Post.swift
//  Wake me App
//
//  Created by 松田羽純 on 2020/03/31.
//  Copyright © 2020 松田羽純. All rights reserved.
//


import UIKit

class Post {
    var objectId: String
    var user: User
    var setTime: Date
//    var setDate: String

    //　値は絶対入る。初期化と同時に値入るよ
    init(objectId: String, user: User, setTime:Date) {
        self.objectId = objectId
        self.user = user
        self.setTime = setTime
//        self.setDate = setDate
    }
  
}
