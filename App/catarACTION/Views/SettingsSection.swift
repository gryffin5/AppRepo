//
//  SettingsSection.swift
//  catarACTION
//
//  Created by Elizabeth Winters on 10/20/20.
//  Copyright © 2020 Sruti Peddi. All rights reserved.
//

import Foundation

protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
}

// Create categories for buttons
enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case Preferences
    case Communications
    
    var description: String {
    switch self {
    // Print when buttons in category are tapped
    case .Preferences: return "User Preferences"
    case .Communications: return "Communications"
    }
}
}

// Add action when logOut button is tapped
enum PreferencesOptions: Int, CaseIterable, SectionType
{
    case editProfile
    case logOut
    
    var containsSwitch: Bool { return false }
    var description: String {
    switch self {
    // Print when buttons are tapped
    case .editProfile: return "Edit Profile"
    case .logOut: return "Log Out"
    }
}
}

// Add action when communication buttons are tapped
enum CommunicationsOptions: Int, CaseIterable, SectionType{
 
 case notifications
 case email
 case reportCrashes
    
      var containsSwitch: Bool {
        switch self {
     
      case .notifications: return true
      case .email: return true
      case .reportCrashes: return true
      }
 
    }
    
      var description: String {
      switch self {
      // Print when buttons are tapped
      case .notifications: return "Notifications"
      case .email: return "Email"
      case .reportCrashes: return "Report Crashes"
      }
}
}


