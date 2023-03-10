//
//  ViewController.swift
//  ToDoList CoreData
//
//  Created by Suraj Jaiswal on 10/02/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let formatter = DateFormatter()
    
    // ------------ Creating TableView Programatically (Computed Property Type) ------------
    
    let tableView : UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var items = [ToDoListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "ToDoList"
        view.addSubview(tableView)  // attaching table to uiView
        getAllItems()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        // ------------ Navigation Controller : Add Item Button ------------

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemBtn))
    }
    
    // ------------ UIAlert Controller : Add Item Buttton ------------
    
    @objc func addItemBtn(){
        let alert = UIAlertController(title: "New Item", message: "Enter new item", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: {[weak self] _ in
            guard let feild = alert.textFields?[0], let newText = feild.text, !newText.isEmpty else{
                return
            }
            
            self?.createItem(itemName: newText)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert,animated: true)
    }
    
    // ------------ TableView Controller : numberOfRows ------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // ------------ TableView Controller : cellForRowAt ------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell") // default cell view (in-built type : adding progrmatically)
        formatter.dateFormat = "HH:mm E, d MMM y"
        let item = items[indexPath.row]
        cell.textLabel?.text = item.itemName
        cell.detailTextLabel?.text = formatter.string(from: item.addedOn ?? Date())
        cell.detailTextLabel?.alpha = 0.7
        return cell
    }
    
    // ------------ TableView Controller : didSelectRow ------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let itemSelected = items[indexPath.row]
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteItem(item: itemSelected)
        }))
        
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let alert = UIAlertController(title: "Edit Item", message: "Enter new detail", preferredStyle: .alert)

            alert.addTextField(configurationHandler: nil)
            alert.textFields?[0].text = itemSelected.itemName
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {[weak self] _ in
                guard let feild = alert.textFields?[0], let text = feild.text, !text.isEmpty else{ return }

                self?.updateItem(oldItem: itemSelected, newItemName: text)

            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            self.present(alert,animated: true)
        }))

        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(sheet,animated: true)
        
    }
    
    // ------------ CRUD Operation ------------

    func getAllItems(){
        do
        {
            items = try context.fetch(ToDoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            tableView.reloadData()
        }
        catch{
            // TODO: Handle Errors
        }
    }
    
    func createItem(itemName : String){
        let newItem = ToDoListItem(context: context)
        newItem.itemName = itemName
        newItem.addedOn = Date()
        
        do{
            try context.save()
            getAllItems()
        }
        catch{
            // TODO: Handle Errors
        }
    }
    
    func updateItem(oldItem : ToDoListItem, newItemName : String){
        oldItem.itemName = newItemName
        oldItem.addedOn = Date()
        do{
            try context.save()
            getAllItems()
        }
        catch{
            // TODO: Handle Errors
        }
    }
    
    func deleteItem(item : ToDoListItem){
        context.delete(item)
        do{
            try context.save()
            getAllItems()
        }
        catch{
            // TODO: Handle Errors
        }
    }
}
