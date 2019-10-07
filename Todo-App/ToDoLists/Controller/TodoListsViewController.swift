//
//  TodoListsViewController.swift
//  Todo-App
//
//  Created by Nguyễn Xuân Nam on 9/14/19.
//  Copyright © 2019 Nguyễn Xuân Nam. All rights reserved.
//

import UIKit
import CoreData

class TodoListsViewController: UIViewController {
    
    @IBOutlet weak var listView: UIView!
    
    @IBOutlet weak var txtActivity: UITextField!
    
    @IBOutlet weak var tableListsView: UITableView!
    
    @IBOutlet weak var tableListsDel: UITableView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    
    var txtTodoLists = ""
    var nameTodoListsToLists = [[String]]()
    var nameTodoListsDelToLists = [[String]]()
    var checkMarkToLists = [[Bool]]()
    var nameTodoLists = [String]()
    var listsDel = [String]()
    var todoListsTitle = ""
    var checkMark = [Bool]()
    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableListsView.dataSource = self
        tableListsView.delegate = self
        tableListsDel.dataSource = self
        tableListsDel.delegate = self
        
        //fetchData()
        CoreDataManager.sharedManager.fetchData(array: &self.nameTodoListsToLists, entityName: KeyLists.share.nameListsArr, forKey: KeyLists.share.keyTodoListsArr)
        CoreDataManager.sharedManager.fetchData(array: &self.nameTodoListsDelToLists, entityName: KeyLists.share.nameListsDelArr, forKey: KeyLists.share.keyTodoListsDelArr)
        CoreDataManager.sharedManager.fetchData(array: &self.checkMarkToLists, entityName: KeyLists.share.nameCheckArr, forKey: KeyLists.share.keyCheckArr)
        
        //setupView
        setupListsView()
        setupBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameTodoLists = nameTodoListsToLists[index]
        listsDel = nameTodoListsDelToLists[index]
        checkMark = checkMarkToLists[index]
        
        for (index,value) in checkMark.enumerated() {
            if value == true {
                listsDel.insert(nameTodoLists[index], at: 0)
                nameTodoLists.remove(at: index)
                checkMark.remove(at: index)
            }
        }
        
        CoreDataManager.sharedManager.updateData(array: &nameTodoListsToLists, value: nameTodoLists, index: nameTodoListsDelToLists.count - index - 1, entityName: KeyLists.share.nameListsArr, forKey: KeyLists.share.keyTodoListsArr)
        CoreDataManager.sharedManager.updateData(array: &nameTodoListsDelToLists, value: listsDel, index: nameTodoListsDelToLists.count - index - 1, entityName: KeyLists.share.nameListsDelArr, forKey: KeyLists.share.keyTodoListsDelArr)
        CoreDataManager.sharedManager.updateData(array: &checkMarkToLists, value: checkMark, index: nameTodoListsDelToLists.count - index - 1, entityName: KeyLists.share.nameCheckArr, forKey: KeyLists.share.keyCheckArr)
        
        lblTitle.text = todoListsTitle
        
        customNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        for (index,value) in checkMark.enumerated() {
            if value == true {
                listsDel.insert(nameTodoLists[index], at: 0)
                nameTodoLists.remove(at: index)
                checkMark.remove(at: index)
            }
        }
        
        CoreDataManager.sharedManager.updateData(array: &nameTodoListsToLists, value: nameTodoLists, index: nameTodoListsDelToLists.count - index - 1, entityName: KeyLists.share.nameListsArr, forKey: KeyLists.share.keyTodoListsArr)
        CoreDataManager.sharedManager.updateData(array: &nameTodoListsDelToLists, value: listsDel, index: nameTodoListsDelToLists.count - index - 1, entityName: KeyLists.share.nameListsDelArr, forKey: KeyLists.share.keyTodoListsDelArr)
        CoreDataManager.sharedManager.updateData(array: &checkMarkToLists, value: checkMark, index: nameTodoListsDelToLists.count - index - 1, entityName: KeyLists.share.nameCheckArr, forKey: KeyLists.share.keyCheckArr)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func customNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .none
        navigationController?.navigationBar.tintColor = .white
    }
    
    func setupListsView() {
        //mainView
        listView.layer.cornerRadius = 10
        
        //txtActivity
        txtActivity.attributedPlaceholder = NSAttributedString(string: "Enter activity…",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func setupBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    @IBAction func btn_AddLists(_ sender: Any) {
        if let txtActivity = txtActivity.text {
            if txtActivity.count > 0 {
                self.nameTodoLists.insert(txtActivity, at: 0)
                self.checkMark.insert(false, at: 0)
                CoreDataManager.sharedManager.updateData(array: &nameTodoListsToLists, value: nameTodoLists, index: nameTodoListsToLists.count - index - 1, entityName: KeyLists.share.nameListsArr, forKey: KeyLists.share.keyTodoListsArr)
                CoreDataManager.sharedManager.updateData(array: &checkMarkToLists, value: checkMark, index: nameTodoListsDelToLists.count - index - 1, entityName: KeyLists.share.nameCheckArr, forKey: KeyLists.share.keyCheckArr)
            }
        }
        txtActivity.text = ""
        
        DispatchQueue.main.async {
            self.tableListsView.reloadData()
        }
    }
}

extension TodoListsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableListsView {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Sửa Nội Dung", message: "Nhập nội dung cần sửa", preferredStyle: UIAlertController.Style.alert)
                let btn_Action = UIAlertAction(title: "Sửa", style: UIAlertAction.Style.default) { (btn_Action) in
                    self.txtTodoLists = alert.textFields?[0].text ?? ""
                    if self.txtTodoLists.count > 0 {
                        self.nameTodoLists[indexPath.row] =  self.txtTodoLists
                        CoreDataManager.sharedManager.updateData(array: &self.nameTodoListsToLists, value: self.nameTodoLists, index: self.nameTodoListsToLists.count - self.index - 1, entityName: KeyLists.share.nameListsArr, forKey: KeyLists.share.keyTodoListsArr)
                    }
                    DispatchQueue.main.async {
                        self.tableListsView.reloadData()
                    }
                }
                let btn_Cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (btn_Cancel) in
                    self.tableListsView.deselectRow(at: indexPath, animated: true)
                }
                
                alert.addTextField { (txtList) in
                }
                alert.addAction(btn_Cancel)
                alert.addAction(btn_Action)
                
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            return
        }
    }
}

extension TodoListsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableListsView {
            return nameTodoLists.count
        } else {
            return listsDel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableListsView,
            let cell = tableView.dequeueReusableCell(withIdentifier: "HOMELISTS") as? TodoListsTableViewCell {
            
            cell.lblNameLists.text = self.nameTodoLists[indexPath.row]
            
            cell.btnDel.addTarget(self, action: #selector(delCell(_:)), for: .touchUpInside)
            
            cell.btnSuccess.addTarget(self, action: #selector(check(_:)), for: .touchUpInside)
            
            return cell
            
        } else if tableView == self.tableListsDel,
            let cell = tableView.dequeueReusableCell(withIdentifier: "TODODEL") as? TodoDelTableViewCell {
            let stringDel = self.listsDel[indexPath.row]
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(stringDel)")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            
            cell.lblListsDel.attributedText = attributeString
            
            cell.btnDel.addTarget(self, action: #selector(delCell2(_:)), for: .touchUpInside)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func delCell(_ sender: UIButton) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Thông báo", message: "Xoá nội dung sẽ không thể khôi phục", preferredStyle: UIAlertController.Style.alert)
            let btn_Action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (btn_Action) in
                let hitPoint = sender.convert(CGPoint.zero, to: self.tableListsView)
                if let indexPath = self.tableListsView.indexPathForRow(at: hitPoint) {
                    self.listsDel.insert(self.nameTodoLists[indexPath.row], at: 0)
                    CoreDataManager.sharedManager.updateData(array: &self.nameTodoListsDelToLists, value: self.listsDel, index: self.nameTodoListsToLists.count - self.index - 1, entityName: KeyLists.share.nameListsDelArr, forKey: KeyLists.share.keyTodoListsDelArr)
                    DispatchQueue.main.async {
                        self.tableListsDel.reloadData()
                    }
                    
                    self.nameTodoLists.remove(at: indexPath.row)
                    self.checkMark.remove(at: indexPath.row)
                    CoreDataManager.sharedManager.updateData(array: &self.nameTodoListsToLists, value: self.nameTodoLists, index: self.nameTodoListsToLists.count - self.index - 1, entityName: KeyLists.share.nameListsArr, forKey: KeyLists.share.keyTodoListsArr)
                    CoreDataManager.sharedManager.updateData(array: &self.checkMarkToLists, value: self.checkMark, index: self.nameTodoListsToLists.count - self.index - 1, entityName: KeyLists.share.nameCheckArr, forKey: KeyLists.share.keyCheckArr)
                    self.tableListsView.beginUpdates()
                    self.tableListsView.deleteRows(at: [indexPath], with: .automatic)
                    self.tableListsView.endUpdates()
                }
            }
            let btn_Cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            alert.addAction(btn_Cancel)
            alert.addAction(btn_Action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func delCell2(_ sender: UIButton) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Thông báo", message: "Xoá nội dung sẽ không thể khôi phục", preferredStyle: UIAlertController.Style.alert)
            let btn_Action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (btn_Action) in
                let hitPoint = sender.convert(CGPoint.zero, to: self.tableListsDel)
                
                if let indexPath = self.tableListsDel.indexPathForRow(at: hitPoint) {
                    self.listsDel.remove(at: indexPath.row)
                    CoreDataManager.sharedManager.updateData(array: &self.nameTodoListsDelToLists, value: self.listsDel, index: self.nameTodoListsToLists.count - self.index - 1, entityName: KeyLists.share.nameListsDelArr, forKey: KeyLists.share.keyTodoListsDelArr)
                    self.tableListsDel.beginUpdates()
                    self.tableListsDel.deleteRows(at: [indexPath], with: .automatic)
                    self.tableListsDel.endUpdates()
                }
            }
            let btn_Cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            alert.addAction(btn_Cancel)
            alert.addAction(btn_Action)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func check(_ sender: UIButton) {
        let hitPoint = sender.convert(CGPoint.zero, to: self.tableListsView)
        if let indexPath = self.tableListsView.indexPathForRow(at: hitPoint) {
            
            if sender.isSelected {
                sender.isSelected = false
                checkMark[indexPath.row] = false
            } else {
                sender.isSelected = true
                checkMark[indexPath.row] = true
            }
        }
        CoreDataManager.sharedManager.updateData(array: &checkMarkToLists, value: checkMark, index: nameTodoListsDelToLists.count - index - 1, entityName: KeyLists.share.nameCheckArr, forKey: KeyLists.share.keyCheckArr)
    }
}
