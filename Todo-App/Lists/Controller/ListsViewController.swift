//
//  ListsViewController.swift
//  Todo-App
//
//  Created by Nguyễn Xuân Nam on 9/14/19.
//  Copyright © 2019 Nguyễn Xuân Nam. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class ListsViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var ListTableView: UITableView!
    
    @IBOutlet weak var btnAdd: UIButton!
    
    var nameLists = [String]()
    var addLists = [String]()
    var todoLists = [[String]]()
    
    
    var txtLists = ""
    var todoTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLists.append("All")
        
        self.ListTableView.dataSource = self
        self.ListTableView.delegate = self
        
        self.ListTableView.isUserInteractionEnabled = true
        
        //fetchData
        CoreDataManager.sharedManager.fetchData(array: &self.addLists, entityName: KeyLists.share.nameLists, forKey: KeyLists.share.keyLists)
        CoreDataManager.sharedManager.fetchDataArray(array: &self.todoLists, entityName: KeyLists.share.nameListsArr, forKey: KeyLists.share.keyTodoListsArr)
        
        btnAdd.layer.cornerRadius = 25
        setupBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //deSel
        if let index = self.ListTableView.indexPathForSelectedRow{
            self.ListTableView.deselectRow(at: index, animated: true)
        }
        
        customNavigationBar()
        getUserName()
        viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func customNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func getUserName() {
        let ref = Database.database().reference()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            DispatchQueue.main.async {
                self.lblName.text = "Hello \(name)"
            }
        }) { (error) in
            print(error.localizedDescription)
        }
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
        let alert = UIAlertController(title: "Add Lists", message: "Nhập nội dung cần thêm", preferredStyle: UIAlertController.Style.alert)
        let btn_Action = UIAlertAction(title: "Thêm", style: UIAlertAction.Style.default) { (btn_Action) in
            self.txtLists = alert.textFields?[0].text ?? ""
            if self.txtLists.count > 0 {
                self.addLists.append(self.txtLists)
                self.todoLists.append([])
                CoreDataManager.sharedManager.insertData(entityName: KeyLists.share.nameLists, forKey: KeyLists.share.keyLists, value: self.txtLists)
                CoreDataManager.sharedManager.insertDataArray(entityName: KeyLists.share.nameListsArr, forKey: KeyLists.share.keyTodoListsArr, value: [])
            }
            self.addLists.removeAll()
            self.todoLists.removeAll()
            CoreDataManager.sharedManager.fetchData(array: &self.addLists, entityName: KeyLists.share.nameLists, forKey: KeyLists.share.keyLists)
            CoreDataManager.sharedManager.fetchDataArray(array: &self.todoLists, entityName: KeyLists.share.nameListsArr, forKey: KeyLists.share.keyTodoListsArr)
            DispatchQueue.main.async {
                self.ListTableView.reloadData()
            }
        }
        let btn_Cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alert.addTextField { (txtList) in
        }
        alert.addAction(btn_Cancel)
        alert.addAction(btn_Action)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension ListsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "TodoListsStoryboard", bundle: nil)
        
        let Todo = storyboard.instantiateViewController(withIdentifier: "TODOLISTS") as! TodoListsViewController
        
        if indexPath.section == 0 {
            Todo.todoListsTitle = nameLists[indexPath.row]
        } else {
            Todo.todoListsTitle = addLists[indexPath.row]
        }
        
        Todo.nameTodoLists = todoLists[indexPath.row]
        
        navigationController?.pushViewController(Todo, animated: true)
    }
}

extension ListsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.nameLists.count
        } else {
            return self.addLists.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LISTSTABLEVIEW", for: indexPath) as! LitsTableViewCell
            
            cell.lblLists.text = nameLists[indexPath.row]
            
            return cell
        } else {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "LISTSADD", for: indexPath) as! ListAddTableViewCell
            
            cell2.lblAddLists.text = addLists[indexPath.row]
            cell2.btnListsDel.addTarget(self, action: #selector(delCell(_:)), for: .touchUpInside)
            
            return cell2
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func delCell(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Thông báo", message: "Xoá nội dung sẽ không thể khôi phục", preferredStyle: UIAlertController.Style.alert)
            let btn_Action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (btn_Action) in
                let hitPoint = sender.convert(CGPoint.zero, to: self.ListTableView)
                
                if let indexPath = self.ListTableView.indexPathForRow(at: hitPoint) {
                    self.addLists.remove(at: indexPath.row)
                    self.todoLists.remove(at: indexPath.row)
                    CoreDataManager.sharedManager.deleteData(entityName: KeyLists.share.nameLists, index: self.addLists.count - indexPath.row)
                    CoreDataManager.sharedManager.deleteData(entityName: KeyLists.share.nameListsArr, index: self.addLists.count - indexPath.row)
                    self.ListTableView.beginUpdates()
                    self.ListTableView.deleteRows(at: [indexPath], with: .automatic)
                    self.ListTableView.endUpdates()
                }
            }
            let btn_Cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            alert.addAction(btn_Cancel)
            alert.addAction(btn_Action)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
