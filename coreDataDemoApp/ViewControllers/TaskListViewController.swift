//
//  ViewController.swift
//  coreDataDemoApp
//
//  Created by Никита Микрюков on 01.10.2020.
//  Copyright © 2020 Никита Микрюков. All rights reserved.
//

import UIKit
import CoreData

class TaskListViewController: UITableViewController {

    private let cellID = "cell"
    var tasks = StorageManager.shared.fetchData()


    // этот метод вызывается всего один раз в начале
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        
    }
    // вызыввется кадый раз после того как на этот экран перешли из дурго экрана
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           tableView.reloadData()
       }
    
    private func setupNavigationBar() {
        title = "Task List"
        // сделать большим и видимым
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // NavigationBarAppirance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithDefaultBackground()
        //настройка цвета для маелькнкого заголовка
        navBarAppearance.titleTextAttributes = [.foregroundColor : UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor : UIColor.white]
        
        navBarAppearance.backgroundColor = UIColor (
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )

        // применяем цвет при скролле
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        // приминяем наш цвет при обычном состоянии
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        //Add button to navigation bar
        // внешний вид кнопки
        navigationItem.rightBarButtonItem  = UIBarButtonItem(
            barButtonSystemItem: .add,
            //где должен реализован метод актион селф потому что в само классе
            target: self,
            // какой метод мы будем использовать при нажатии на кнопку
            action: #selector(addTask)
        )
        navigationController?.navigationBar.tintColor = .white
    }
    @objc private func addTask() {
        showAlert()
    }

}

// MARK: - Table view data source
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.name
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let task = tasks[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic);         StorageManager.shared.delete(task)
        }
        let editAction = UIContextualAction(style: .destructive, title: "Edit") {  (contextualAction, view, boolValue) in
            tableView.deselectRow(at: indexPath, animated: true)
            
            self.showAlert(task: task){
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        editAction.backgroundColor = UIColor.blue
        
        return UISwipeActionsConfiguration(actions: [editAction, deleteAction])
    }
    
}
// MARK: - Alert Controller
extension TaskListViewController {
    
    private func showAlert(task: Task? = nil, delivery: (() -> Void)? = nil) {
        
        var title = "New Task"
        let message = "What do you want to do?"
        if task != nil { title = "Update Task" }
        
        let alert = AlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.alert(task: task) { newTaskValue in
            // проверка на введеные данные в стркоу
            if let task = task, let delivery = delivery {
                StorageManager.shared.edit(task, edit: newTaskValue)
                
                delivery()
            } else {
                StorageManager.shared.save(newTaskValue) { task in
                    self.tasks.append(task)
                    self.tableView.insertRows(
                        at: [IndexPath(row: self.tasks.count - 1, section: 0)],
                        with: .automatic
                    )
                }
            }
        }
        
        present(alert, animated: true)
    }
}
