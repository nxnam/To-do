//
//  ListAddTableViewCell.swift
//  Todo-App
//
//  Created by Nguyễn Xuân Nam on 9/23/19.
//  Copyright © 2019 Nguyễn Xuân Nam. All rights reserved.
//

import UIKit

class ListAddTableViewCell: UITableViewCell {

    @IBOutlet weak var lblAddLists: UILabel!
    
    @IBOutlet weak var btnListsDel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
