//
//  TodoListsViewController.swift
//  Todo-App
//
//  Created by Nguyễn Xuân Nam on 9/14/19.
//  Copyright © 2019 Nguyễn Xuân Nam. All rights reserved.
//

import UIKit

class TodoListsViewController: UIViewController {
    
    @IBOutlet weak var listView: UIView!
    
    @IBOutlet weak var txtActivity: UITextField!
    
    @IBOutlet weak var tableListsView: UITableView!
    
    @IBOutlet weak var tableListsDel: UITableView!
    
    var nameLists = ["Do loundry","Clean kithen","Cook dinner"]
    var listsDel = ["Eat a cookie"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "BACK", style: .plain, target: self, action: nil)
        
        tableListsView.dataSource = self
        tableListsView.delegate = self
        tableListsDel.dataSource = self
        tableListsDel.delegate = self
        
        setupListsView()
        setupBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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
                self.nameLists.insert(txtActivity, at: 0)
            }
        }
        DispatchQueue.main.async {
            self.tableListsView.reloadData()
        }
    }
    
    @IBAction func btn_Back(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ListsStoryboard", bundle: nil)
        
        let Lists = storyboard.instantiateViewController(withIdentifier: "LISTS") as! ListsViewController
        
        self.present(Lists, animated: true)
    }
    
}

extension TodoListsViewController: UITableViewDelegate {
    
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
        let hitPoint = sender.convert(CGPoint.zero, to: tableListsView)
        if let indexPath = tableListsView.indexPathForRow(at: hitPoint) {
            
            self.listsDel.insert(self.nameLists[indexPath.row], at: 0)
            DispatchQueue.main.async {
                self.tableListsDel.reloadData()
            }
            self.nameLists.remove(at: indexPath.row)
            tableListsView.beginUpdates()
            tableListsView.deleteRows(at: [indexPath], with: .automatic)
            tableListsView.endUpdates()
            
        }
    }
    
    @objc func delCell2(_ sender: UIButton) {
        let hitPoint = sender.convert(CGPoint.zero, to: tableListsDel)
        if let indexPath = tableListsDel.indexPathForRow(at: hitPoint) {
        
            self.listsDel.remove(at: indexPath.row)
            tableListsDel.beginUpdates()
            tableListsDel.deleteRows(at: [indexPath], with: .automatic)
            tableListsDel.endUpdates()
            
        }
    }
}
