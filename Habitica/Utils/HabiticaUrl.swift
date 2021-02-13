//
//  HabiticaUrl.swift
//  Habitica
//
//  Created by Dominik Hażak on 30/01/2020.
//  Copyright © 2020 Dominik Hażak. All rights reserved.
//

import Foundation

struct HabiticaUrl {
    static var login:URL {
        get {
            URL(string: "https://habitica.com/api/v3/user/auth/local/login")!
        }
    }
    static var tasks:URL {
        get {
            URL(string: "https://habitica.com/api/v3/tasks/user")!
        }
    }
    static var submit:(String,String?) -> URL = { taskId, direction in
        return URL(string: "https://habitica.com/api/v3/tasks/\(taskId)/score/\(direction ?? "up")")!
    }
    
    static var user:([String]) -> URL = { fieldsList in
        if !fieldsList.isEmpty{
            let fields = fieldsList.joined(separator: ",")
            return URL(string:"https://habitica.com/api/v3/user?userFields=\(fields)")!
        }
        return URL(string:"https://habitica.com/api/v3/user")!
            
    }
}
