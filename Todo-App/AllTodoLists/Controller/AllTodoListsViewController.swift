//
//  AllTodoListsViewController.swift
//  Todo-App
//
//  Created by Nguyễn Xuân Nam on 10/3/19.
//  Copyright © 2019 Nguyễn Xuân Nam. All rights reserved.
//

import UIKit

class AllTodoListsViewController: UIViewController {

    @IBOutlet weak var AllTodoTableView: UITableView!
    
    var allTodoLists = [[String]]()
    var nameAllLists = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AllTodoTableView.delegate = self
        AllTodoTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        AllTodoTableView.layer.cornerRadius = 5
        
        customNavigationBar()
        setupBackground()
    }
    
    func customNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .none
        navigationController?.navigationBar.tintColor = .white
    }
    
    func setupBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
}

extension AllTodoListsViewController: UITableViewDelegate {
    
}

extension AllTodoListsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return allTodoLists.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nameAllLists[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTodoLists[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ALLTODOCELL", for: indexPath) as! AllTodoListsTableViewCell
        
        cell.lblAllTodoLists.text = allTodoLists[indexPath.section][indexPath.row]
        
        return cell
    }
    
    
}
