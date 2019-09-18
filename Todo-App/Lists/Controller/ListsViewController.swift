//
//  ListsViewController.swift
//  Todo-App
//
//  Created by Nguyễn Xuân Nam on 9/14/19.
//  Copyright © 2019 Nguyễn Xuân Nam. All rights reserved.
//

import UIKit

class ListsViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var ListTableView: UITableView!
    
    @IBOutlet weak var btnAdd: UIButton!
    
    var iconImages = [UIImage]()
    var nameLists = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLists.append("All to-do's")
        nameLists.append("House to-do's")
        iconImages.append(UIImage(named: "all")!)
        iconImages.append(UIImage(named: "home")!)
        
        self.ListTableView.dataSource = self
        self.ListTableView.delegate = self
        
        self.ListTableView.isUserInteractionEnabled = true
        
        btnAdd.layer.cornerRadius = 25
        setupBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        viewDidLayoutSubviews()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews(){
        ListTableView.frame = CGRect(x: ListTableView.frame.origin.x, y: ListTableView.frame.origin.y, width: ListTableView.frame.size.width, height: ListTableView.contentSize.height)
        ListTableView.reloadData()
    }
    
    func setupBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func setupTitleView() {
        imgUser.layer.cornerRadius = 50
    }
    
    @IBAction func btn_Add(_ sender: Any) {
        print("111")
    }
    
}

extension ListsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "TodoListsStoryboard", bundle: nil)
        
        let Todo = storyboard.instantiateViewController(withIdentifier: "TODOLISTS") as! TodoListsViewController
        
        self.present(Todo, animated: true)
    }
}

extension ListsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nameLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LISTSTABLEVIEW", for: indexPath) as! LitsTableViewCell
        
        cell.lblLists.text = nameLists[indexPath.row]
        cell.iconLists.image = iconImages[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
