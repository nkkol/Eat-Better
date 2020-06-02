//
//  SavedRecipesTableViewController.swift
//  Eat Better
//
//  Created by Inna Litvinenko on 27.05.2020.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import UIKit
import CoreData

class SavedRecipesTableViewController: UITableViewController {

    let editButton = UIBarButtonItem()
    let deleteButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        setEditing(false, animated: true)
        tabBarController?.title = "Saved Recipes"
        tableView.reloadData()
        
        setButtons ()
        tabBarController?.navigationItem.rightBarButtonItems = [editButton]
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.navigationItem.rightBarButtonItems = []
    }
    
    func setButtons () {
        editButton.title = "Edit"
        editButton.target = self
        editButton.action = #selector(editButtonClicked)
        
        deleteButton.title = "Delete"
        deleteButton.target = self
        deleteButton.action = #selector(deleteButtonClicked)
    }
    
    @objc func deleteButtonClicked() {
        if let selectedRows = tableView.indexPathsForSelectedRows, isEditing {
            var toDelete = [SavedRecipe]()
            for indexPath in selectedRows  {
                toDelete.append(DBManager.share.savedRecipes?[indexPath.row] ?? SavedRecipe())
            }
            for recipe in toDelete {
                if let index = DBManager.share.savedRecipes?.firstIndex(of: recipe) {
                    DBManager.share.delete(recipe: DBManager.share.savedRecipes?[index] ?? SavedRecipe())
                }
            }
            tableView.deleteRows(at: selectedRows, with: .automatic)
        }
    }
    
    @objc func editButtonClicked() {
        setEditing(!isEditing, animated: true)
        if isEditing {
            editButton.title = "Done"
            tabBarController?.navigationItem.rightBarButtonItems = [editButton, deleteButton]
        }
        else {
            editButton.title = "Edit"
            tabBarController?.navigationItem.rightBarButtonItems = [editButton]
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DBManager.share.savedRecipes?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell") as? SearchResultTableViewCell
        cell?.img.image = UIImage()
        cell?.name.text = DBManager.share.savedRecipes?[indexPath.row].name
        cell?.setupActivityIndicator()
        NetworkManager.loadImage ( DBManager.share.savedRecipes?[indexPath.row].image ?? "") { img in
            DispatchQueue.main.async {
                cell?.img.image = img
                cell?.activityIndicator.removeFromSuperview()
            }
        }
        return cell ?? SearchResultTableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") {(action, view, completion) in
            DBManager.share.delete(recipe: DBManager.share.savedRecipes?[indexPath.row] ?? SavedRecipe())
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
           completion(true)
           }
        return action
       }
    
}
