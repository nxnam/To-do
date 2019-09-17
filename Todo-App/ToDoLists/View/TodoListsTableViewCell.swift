//
//  TodoListsTableViewCell.swift
//  Todo-App
//
//  Created by Nguyễn Xuân Nam on 9/15/19.
//  Copyright © 2019 Nguyễn Xuân Nam. All rights reserved.
//

import UIKit

class TodoListsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNameLists: UILabel!
    
    @IBOutlet weak var btnDel: UIButton!
    
    @IBAction func btn_Del(_ sender: Any) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
