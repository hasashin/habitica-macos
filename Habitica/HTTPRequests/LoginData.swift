//
//  LoginData.swift
//  Habitica
//
//  Created by Dominik Hażak on 23/01/2020.
//  Copyright © 2020 Dominik Hażak. All rights reserved.
//

import Foundation

struct LoginData{
    var apiToken: String
    var id: String
    var newUser: Bool
    var username: String
    
    init?(from data:[String:Any]){
        guard
            let apiToken = data["apiToken"] as? String,
            let newUser = data["newUser"] as? Bool,
            let username = data["username"] as? String,
            let id = data["id"] as? String
        else{
            return nil
        }
        self.apiToken = apiToken
        self.username = username
        self.newUser = newUser
        self.id = id
    }
}
