//
//  SettingsSection.swift
//  catarACTION
//
//  Created by Elizabeth Winters on 8/16/20.
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
    case logOut
 
    var containsSwitch: Bool { return false }
    var description: String {
    switch self {
    // Print when buttons are tapped
    case .logOut: return "Log Out"
    }
}
}

// Add action when communication buttons are tapped
enum CommunicationsOptions: Int, CaseIterable, SectionType{
 
 case email
 case reportCrashes
    
      var containsSwitch: Bool {
        switch self {
      case .email: return true
      case .reportCrashes: return true
      }
 
    }
    
      var description: String {
      switch self {
      // Print when buttons are tapped
      case .email: return "Email"
      case .reportCrashes: return "Report Crashes"
      }
}
}


