//
//  HomeViewController.swift
//  catarACTION
//  Copyright 2020 Sruti Peddi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let tabBar = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTabBar()
    }
    func addTabBar ()
    {
        let analysisVC = (self.storyboard?.instantiateViewController(withIdentifier: "AnalysisVC"))! as! AnalysisViewController
        let cameraVC = (self.storyboard?.instantiateViewController(withIdentifier: "CameraVC"))! as! CameraViewController
        
        let settingsVC = SettingsViewController()
        
        let analysisItem = UITabBarItem(title: "Analysis", image: UIImage(named: "gallery-icon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "blueGallery-icon"))
        analysisItem.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: -5, right: -10)
        
        let cameraItem = UITabBarItem(title: "Camera", image: UIImage(named: "camera-icon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "blueCamera-icon"))
        
        let settingsItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings-icon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "blueSettings-icon"))
        
        analysisVC.tabBarItem = analysisItem
        cameraVC.tabBarItem = cameraItem
        settingsVC.tabBarItem = settingsItem
        
        tabBar.viewControllers = [analysisVC, cameraVC, settingsVC]
        
        self.view.addSubview(tabBar.view)
        
    }

    }
    



