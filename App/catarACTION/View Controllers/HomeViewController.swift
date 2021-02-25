//
//  HomeViewController.swift
//  catarACTION
//
//  Created by Elizabeth Winters on 10/20/20.
//  Copyright © 2020 Sruti Peddi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let tabBar = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        addTabBar()
        // Do any additional setup after loading the view.
        
    }
    
    func addTabBar ()
    {
        // Transition to vc when tab bar item is tapped
        let cameraVC = (self.storyboard?.instantiateViewController(withIdentifier: "CameraVC"))! as! CameraViewController
        
        let settingsVC = SettingsViewController()
        
        // Style items
        let cameraItem = UITabBarItem(title: "Camera", image: UIImage(named: "camera-icon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "blueCamera-icon"))
        
        let settingsItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings-icon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "blueSettings-icon"))
        
        // Create tabs and Organize
        cameraVC.tabBarItem = cameraItem
        settingsVC.tabBarItem = settingsItem
        
        tabBar.viewControllers = [cameraVC, settingsVC]
        
        self.view.addSubview(tabBar.view)
        
    }

    }
    



