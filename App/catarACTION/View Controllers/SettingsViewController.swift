//
//  SettingsViewController.swift
//  catarACTION
//
//  Created by Elizabeth Winters on 11/15/20.
//  Copyright © 2020 Sruti Peddi. All rights reserved.
//
import UIKit


    private let reuseIdentifier = "SettingsCell"
    
    class SettingsViewController: UIViewController {
    
        // MARK: - Properties
        var tableView: UITableView!
        var userInfoHeader: UserInfoHeader!
        // MARK: - Init
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationController?.isNavigationBarHidden = true
           view.backgroundColor = .white
            configureUI()
        }
        // MARK: - Helper Functions
        // Construct settings table
        func configureTableView() {
            tableView = UITableView()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = 60
    
            tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
            view.addSubview(tableView)
            tableView.frame = view.frame
    
            let frame = CGRect(x: 0, y: 86, width: view.frame.width, height: 100)
            userInfoHeader = UserInfoHeader(frame: frame)
            tableView.tableHeaderView = userInfoHeader
            tableView.tableFooterView = UIView()
        }
        // Additional details
        func configureUI() {
            configureTableView()
    
            navigationController?.navigationBar.isTranslucent = true
    
        }
        
    }

    extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return SettingsSection.allCases.count
        }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            guard let section = SettingsSection(rawValue: section) else { return 0 }
            
                switch section {
                case .Preferences: return PreferencesOptions.allCases.count
                case .Communications: return CommunicationsOptions.allCases.count
                }
            }
        // style sections
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let view = UIView()
            view.backgroundColor = UIColor(red: 0.0, green: 122.0/255, blue: 1.0, alpha: 1)
            
            let title = UILabel()
            title.font = UIFont.boldSystemFont(ofSize: 16)
            title.textColor = .white
            title.text = SettingsSection(rawValue: section)?.description
            view.addSubview(title)
            title.translatesAutoresizingMaskIntoConstraints = false
            title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
            
            return view
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 40
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
            
            guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell()}
            // Allow user to choose different sections
            switch section {
            case .Preferences:
                let preferences = PreferencesOptions(rawValue: indexPath.row)
                cell.sectionType = preferences
            case .Communications:
                let communications = CommunicationsOptions(rawValue: indexPath.row)
            cell.sectionType = communications
            }
            
            return cell
        }
        // Return user to defaultvc when logout button is tapped
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let section = SettingsSection(rawValue: indexPath.section) else { return }
            switch section {
                      case .Preferences:
                print(PreferencesOptions(rawValue: indexPath.row)?.description as Any)
                let def = UserDefaults.standard
                def.set(false, forKey: "is_authenticated") // save true flag to UserDefaults
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let defaultController = storyboard.instantiateViewController(withIdentifier: "DefaultVC") as! ViewController
                let controller = UINavigationController(rootViewController: defaultController)
                self.present(controller, animated: true, completion: nil)
                
                case .Communications:
                        print(CommunicationsOptions(rawValue: indexPath.row)?.description as Any)
                      }

        }
    }


