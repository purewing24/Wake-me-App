//
//  TimelineTableViewCell.swift
//  Wake me App
//
//  Created by 松田羽純 on 2020/03/23.
//  Copyright © 2020 松田羽純. All rights reserved.
//

import UIKit

//protocol TimelineTableViewCellDelegate {
//    func didTapWakeUpButton(tableViewCell: UITableViewCell, button: UIButton)
//}

class TimelineTableViewCell: UITableViewCell {
    
//    var delegate: TimelineTableViewCellDelegate?
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userIdNameLabel: UILabel!
    @IBOutlet var setTimeLabel: UILabel!
    @IBOutlet var statesImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
