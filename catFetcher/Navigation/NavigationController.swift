//
//  NavigationController.swift
//  catFetcher
//
//  Created by tixomark on 3/6/21.
//

import UIKit
import CoreData

class NavigationController: UINavigationController {
    
    let catVC = CatBrowserViewController()
    lazy var transitionManager = SettingsPresentationControllerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [catVC]
        
        catVC.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(settings))
        catVC.navigationItem.rightBarButtonItem?.tintColor = .systemPink
    }

    @objc func settings() {
        let settingsVC = SettingsViewController()
        settingsVC.transitioningDelegate = transitionManager
        settingsVC.modalPresentationStyle = .custom
        present(settingsVC, animated: true, completion: nil)

    }

}
