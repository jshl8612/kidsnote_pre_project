//
//  HomeViewController.swift
//  kidsnote
//
//  Created by Steven Jiang on 2023/01/02.
//

import UIKit

class HomeViewController: UIViewController {
    fileprivate var homeView: HomeView {
        return self.view as! HomeView
    }
    
    override func loadView() {
        view = HomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = homeView.searchBar
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
