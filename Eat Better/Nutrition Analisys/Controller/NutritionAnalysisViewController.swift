//
//  NutritionAnalysisViewController.swift
//  Eat Better
//
//  Created by Inna Litvinenko on 27.05.2020.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import UIKit
import ANActivityIndicator

class NutritionAnalysisViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var kcalLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var nutrientsCollectionView: UICollectionView!
    
    var apiClient = ApiClient()
    var calories = Double()
    var weight = Double()
    var nutrients = [Nutrient]()
    
    var indicator = ANActivityIndicatorView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let dimmingView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nutrientsCollectionView.delegate = self
        nutrientsCollectionView.dataSource = self
        kcalLabel.isHidden = true
        weightLabel.isHidden = true
        nutrientsCollectionView.isHidden = true
        prepareForLoading()
        setDoneButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.tabBarController?.title = "Nutrition Analysis"
    }

    func getSearchResults (ing: String) {
        let url = NetworkManager.prepareForAnalyze(textView.text ?? "")
        NetworkManager.searchRecipes (urlString: url) { data in
        self.apiClient.fetchAnalysis(data) { analysis in
            self.calories = analysis.calories
            self.nutrients = analysis.nutrients
            self.weight = analysis.weight
            if self.nutrients.count == 0 {
                self.kcalLabel.isHidden = true
                self.weightLabel.isHidden = true
                self.nutrientsCollectionView.isHidden = true
                let alert = UIAlertController(title: "Ooops", message: "The nutrition for some ingredients can not been calculated. Please check the ingredient spelling or if you have entered a quantities for the ingredients.", preferredStyle: UIAlertController.Style.alert)
                 alert.addAction(UIAlertAction(title: "OK :(", style: UIAlertAction.Style.default, handler: nil))
                 self.present(alert, animated: true, completion: nil)
            }
            else {
                self.dimmingView.removeFromSuperview()
                self.indicator.removeFromSuperview()
                self.kcalLabel.isHidden = false
                self.weightLabel.isHidden = false
                self.nutrientsCollectionView.isHidden = false
                self.setupAnalisys()
            }
        }
    }
    }
    
    func prepareForLoading() {
        dimmingView.backgroundColor = .black
        dimmingView.frame = view.frame
        dimmingView.alpha = 0.7
        let side = CGFloat(50)
        indicator = ANActivityIndicatorView.init(frame:
                                                CGRect(x: view.center.x - side/2,
                                                y: view.center.y - side/2,
                                                width: side, height: side),
                                                animationType: .ballClipRotateMultiple)
        indicator.startAnimating()
    }

    
    func setupAnalisys() {
        kcalLabel.text = "Calories: " + String(format: "%.2f", calories) + " kcal"
        weightLabel.text = "Weight: " + String(format: "%.2f", weight) + " g"
        nutrientsCollectionView.reloadData()
    }

    @IBAction func analyseButtonClicked(_ sender: Any) {
        getSearchResults (ing: textView.text)
        DispatchQueue.main.async {
            self.view.addSubview(self.dimmingView)
            self.view.addSubview(self.indicator)
            self.view.endEditing(true)
        }
    }
    
    func setDoneButton() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        toolbar.sizeToFit()
        textView.inputAccessoryView = toolbar
    }
    
    @objc func done() {
        textView.endEditing(true)
    }
}

extension NutritionAnalysisViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nutrients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = nutrientsCollectionView.dequeueReusableCell(withReuseIdentifier: "AnalisysNutrientCollectionViewCell", for: indexPath) as? AnalisysNutrientCollectionViewCell
        if indexPath.row % 2 == 0 {
            cell?.backgroundColor = .systemGreen
        }
        else {
            cell?.backgroundColor = .systemOrange
        }
        cell?.fromDailyLabel.text = String(format: "%.2f", nutrients[indexPath.row].fromDaily ?? 0) + " %"
        cell?.nameLabel.text = nutrients[indexPath.row].label
        cell?.quantityUnitLabel.text = String(format: "%.2f", nutrients[indexPath.row].quantity) + " " + nutrients[indexPath.row].unit
        return cell ?? AnalisysNutrientCollectionViewCell()
    }
    
}
