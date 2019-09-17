//
//  TodoDelTableViewCell.swift
//  Todo-App
//
//  Created by Nguyễn Xuân Nam on 9/16/19.
//  Copyright © 2019 Nguyễn Xuân Nam. All rights reserved.
//

import UIKit

class TodoDelTableViewCell: UITableViewCell {

    @IBOutlet weak var lblListsDel: UILabel!
    
    @IBOutlet weak var btnDel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
