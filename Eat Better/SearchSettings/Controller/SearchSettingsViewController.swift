//
//  SearchSettingsViewController.swift
//  Eat Better
//
//  Created by Inna Litvinenko on 5/20/20.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import UIKit

class SearchSettingsViewController: UIViewController {
    
    @IBOutlet weak var healthLabelsTableView: UITableView!
    @IBOutlet weak var dietLabelsTableView: UITableView!
    @IBOutlet weak var kcalLabel: UILabel!
    @IBOutlet weak var kcalTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        healthLabelsTableView.delegate = self
        healthLabelsTableView.dataSource = self
        dietLabelsTableView.delegate = self
        dietLabelsTableView.dataSource = self

        setUI()
        setDoneButtonOnKcal()
        SearchSettingsDataManager.firstFill()

    }
    
    func setDoneButtonOnKcal() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        toolbar.sizeToFit()
        kcalTextField.inputAccessoryView = toolbar
    }
    
    @objc func done() {
        kcalTextField.endEditing(true)
    }
    
    func setUI() {
        healthLabelsTableView.isHidden = true
        dietLabelsTableView.isHidden = true
        kcalLabel.isHidden = true
        kcalTextField.isHidden = true
        title = "Additional settings"
        kcalTextField.text = SearchSettingsDataManager.calories
    }
    
    
    @IBAction func healthLabelsClicked(_ sender: Any) {
        healthLabelsTableView.isHidden = !healthLabelsTableView.isHidden
    }
    @IBAction func dietLabelsClicked(_ sender: Any) {
        dietLabelsTableView.isHidden = !dietLabelsTableView.isHidden
    }
    
    @IBAction func caloriesClicked(_ sender: Any) {
        kcalLabel.isHidden = !kcalLabel.isHidden
        kcalTextField.isHidden = !kcalTextField.isHidden
    }
    
    @IBAction func caloriesChanged(_ sender: Any) {
        SearchSettingsDataManager.calories = kcalTextField.text ?? ""
    }
    
}

extension SearchSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.tag == 0 ? SearchSettingsDataManager.healthLabelsDetails.count : SearchSettingsDataManager.dietLabelsDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if  tableView.tag == 0 {
            cell?.textLabel?.text =  SearchSettingsDataManager.sortedHealthLabelsDetails()[indexPath.row].key
            cell?.detailTextLabel?.text = SearchSettingsDataManager.sortedHealthLabelsDetails()[indexPath.row].value
            if SearchSettingsDataManager.selectedHealthLabels[cell?.textLabel?.text ?? ""] == true {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
        else {
            cell?.textLabel?.text = SearchSettingsDataManager.sortedDietLabelsDetails()[indexPath.row].key
            cell?.detailTextLabel?.text =   SearchSettingsDataManager.sortedDietLabelsDetails()[indexPath.row].value
            if SearchSettingsDataManager.selectedDietLabels[cell?.textLabel?.text ?? ""] == true {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectDeselect(true, tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectDeselect(false, tableView, indexPath)
    }
    
    func selectDeselect (_ flag: Bool, _ tableView : UITableView, _ indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if tableView.tag == 0 {
            SearchSettingsDataManager.selectedHealthLabels[cell?.textLabel?.text ?? ""] = flag
        }
        else {
            SearchSettingsDataManager.selectedDietLabels[cell?.textLabel?.text ?? ""] = flag
        }
    }
}
