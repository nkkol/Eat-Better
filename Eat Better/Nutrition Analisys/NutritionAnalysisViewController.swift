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
    
    @IBOutlet weak var textField: UITextView!
    
    var apiClient = ApiClient()
    var indicator = ANActivityIndicatorView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let dimmingView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForLoading()
        getSearchResults ()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.tabBarController?.title = "Nutrition Analysis"
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

     func getSearchResults () {
    NetworkManager.searchRecipes (urlString: URL(string:  "https://api.edamam.com/api/nutrition-data?app_id=78f69e50&app_key=96a355c730f9c3659f59eeedac12db8c&ingr=1%20large%20apple")!) { data in
        self.apiClient.fetchAnalysis(data) { analysis in
            print(analysis)
            self.indicator.removeFromSuperview()
            self.dimmingView.removeFromSuperview()
        }
    }
    }

    @IBAction func analyseButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AnalysisStoryboard", bundle: nil)
        let analysisViewController = storyboard.instantiateViewController(withIdentifier: "AnalysisViewController") as? AnalysisViewController
        navigationController?.showDetailViewController(analysisViewController ?? self, sender: nil)

    }
}
