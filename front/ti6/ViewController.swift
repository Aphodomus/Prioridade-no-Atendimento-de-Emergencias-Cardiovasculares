//
//  ViewController.swift
//  ti6
//
//  Created by Larissa Kaweski Siqueira on 13/03/23.
//

import UIKit

class ViewController: UIViewController {
    
    let tabBar = UITabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()
        tab()
    }
    
    func tab() {
        tabBar.tabBar.isTranslucent = false
        tabBar.tabBar.backgroundColor = .black
        tabBar.tabBar.tintColor = .red
        tabBar.tabBar.unselectedItemTintColor = .white
        
        let homeVC = HomeViewController()
        let diagnosticVC = UploadPhotoViewController()
        
        let navHomeController = UINavigationController(rootViewController: homeVC)
        let navDiagnosticController = UINavigationController(rootViewController: diagnosticVC)
        
        navHomeController.isNavigationBarHidden = false
        navDiagnosticController.isNavigationBarHidden = false
        
        let userImage = UIImage(systemName: "person.fill")
        let diagnosticImage = UIImage(systemName: "waveform.path.ecg")
        
        let tabItem1 = UITabBarItem(title: "Patients", image: userImage, tag: 0)
        let tabItem2 = UITabBarItem(title: "Diagnostic", image: diagnosticImage, tag: 1)
        
        homeVC.tabBarItem = tabItem1
        diagnosticVC.tabBarItem = tabItem2
        
        tabBar.viewControllers = [navHomeController, navDiagnosticController]
        self.view.addSubview(tabBar.view)
    }

}
