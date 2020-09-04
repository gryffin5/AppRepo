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

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case Preferences
    case Communications
    
    var description: String {
    switch self {
    case .Preferences: return "User Preferences"
    case .Communications: return "Communications"
    }
}
}
enum PreferencesOptions: Int, CaseIterable, SectionType
{
    case logOut
 
    var containsSwitch: Bool { return false }
    var description: String {
    switch self {
    case .logOut: return "Log Out"
    }
}
}
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
      case .email: return "Email"
      case .reportCrashes: return "Report Crashes"
      }
}
}


