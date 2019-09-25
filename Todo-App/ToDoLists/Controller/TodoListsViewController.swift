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
    var nameLists = [String]()
    var listsDel = [String]()
    var todoListsTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableListsView.dataSource = self
        tableListsView.delegate = self
        tableListsDel.dataSource = self
        tableListsDel.delegate = self
        
        setupListsView()
        setupBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lblTitle.text = todoListsTitle
        
        //fetchData()
        CoreDataManager.sharedManager.fetchData(array: &nameLists, entityName: KeyCoreData.share.nameTodoLists , forKey: KeyCoreData.share.keyTodoList)
        CoreDataManager.sharedManager.fetchData(array: &listsDel, entityName: KeyCoreData.share.nameTodoListsDel, forKey: KeyCoreData.share.keyTodoListDel)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
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
                CoreDataManager.sharedManager.insertData(entityName: KeyCoreData.share.nameTodoLists, forKey: KeyCoreData.share.keyTodoList, value: txtActivity)
            }
        }
        txtActivity.text = ""
        nameLists.removeAll()
        CoreDataManager.sharedManager.fetchData(array: &nameLists, entityName: KeyCoreData.share.nameTodoLists , forKey: KeyCoreData.share.keyTodoList)
        
        DispatchQueue.main.async {
            self.tableListsView.reloadData()
        }
    }
    
    @IBAction func btn_Back(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ListsStoryboard", bundle: nil)
        
        let Lists = storyboard.instantiateViewController(withIdentifier: "LISTS") as! ListsViewController
        
        self.present(Lists, animated: false, completion: nil)
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
                        self.nameLists[indexPath.row] =  self.txtTodoLists
                        CoreDataManager.sharedManager.updateData(array: &self.nameLists, value: self.txtTodoLists, index: (self.nameLists.count - indexPath.row - 1), entityName: KeyCoreData.share.nameTodoLists, forKey: KeyCoreData.share.keyTodoList)
                        self.nameLists.removeAll()
                        CoreDataManager.sharedManager.fetchData(array: &self.nameLists, entityName: KeyCoreData.share.nameTodoLists , forKey: KeyCoreData.share.keyTodoList)
                    }
                    DispatchQueue.main.async {
                        self.tableListsView.reloadData()
                    }
                }
                let btn_Cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
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
            return nameLists.count
        } else {
            return listsDel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableListsView,
            let cell = tableView.dequeueReusableCell(withIdentifier: "HOMELISTS") as? TodoListsTableViewCell {
            
            cell.lblNameLists.text = self.nameLists[indexPath.row]
            
            cell.btnDel.addTarget(self, action: #selector(delCell(_:)), for: .touchUpInside)
            
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
                    self.listsDel.insert(self.nameLists[indexPath.row], at: 0)
                    CoreDataManager.sharedManager.insertData(entityName: KeyCoreData.share.nameTodoListsDel, forKey: KeyCoreData.share.keyTodoListDel, value: self.nameLists[indexPath.row])
                    
                    DispatchQueue.main.async {
                        self.tableListsDel.reloadData()
                    }
                    
                    self.nameLists.remove(at: indexPath.row)
                    CoreDataManager.sharedManager.deleteData(entityName: KeyCoreData.share.nameTodoLists, index: indexPath.row)
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
                    CoreDataManager.sharedManager.deleteData(entityName: KeyCoreData.share.nameTodoListsDel, index: indexPath.row)
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
}
