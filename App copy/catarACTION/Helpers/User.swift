//
//  User.swift
//  catarACTION
//
//  Created by Elizabeth Winters on 8/6/20.
//  Copyright © 2020 Sruti Peddi. All rights reserved.
//

import Foundation
class User: Codable {
   static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
       // 2
       if writeToUserDefaults {
           // 3
           if let data = try? JSONEncoder().encode(user) {
               // 4
               UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
           }
       }

   }

}
