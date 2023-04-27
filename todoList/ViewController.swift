//
//  ViewController.swift
//  todoList
//
//  Created by Mohan K on 10/02/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var todoTextField: UITextField!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var todoList: UITableView!
    
    var TodoArray=[String]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
  
        todoList.delegate = self
        todoList.dataSource  = self
        if let data = UserDefaults.standard.object(forKey: "todo list") as? [String]
        {
            TodoArray = data
            statusLbl.text = "\(TodoArray.count) Task Pending is in Todo List"
        }
        else {
            
            statusLbl.text = "No task is Pending"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
               NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        todoList.contentInset = .zero
       }
   
    @objc private func keyboardWillShow(notification: NSNotification) {
           if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
               todoList.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + todoList.rowHeight, right: 0)
           }
        
    }
    @IBAction func saveBtn(_ sender: Any) {
        if todoTextField.text != ""
        {
            TodoArray.append(todoTextField.text!)
            UserDefaults.standard.set(TodoArray,forKey: "todo list")
            todoList.reloadData()
            statusLbl.text = "New Task Going TO added in list"
            todoTextField.text = ""
        }
        else {
            statusLbl.text = "Kindly ente your task"
        }
    }
    
    
}

extension ViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = todoList.dequeueReusableCell(withIdentifier: "todocell" , for: indexPath)
        cell.textLabel?.text = TodoArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todoList.deselectRow(at: indexPath, animated: true)
        let alert = UIAlertController(title: "Edit", message: "Edit the todo list as your wish", preferredStyle: .alert)
        
        let update = UIAlertAction(title: "Update", style: .default) { action in
//            let updatedModels = self.textLabel?.text
            DispatchQueue.main.async { [self] in
                todoList.reloadData()
            }
        }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
                DispatchQueue.main.async { [self] in
                    todoList.reloadData()
                }
            }
            alert.addAction(update)
            alert.addAction(cancel)
        alert.addTextField {_ in
//            self.textLabel?.text = _
        }
        present(alert, animated: true,completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return.delete
    }
}
