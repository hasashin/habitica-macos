//
//  LoginResponse.swift
//  Habitica
//
//  Created by Dominik Hażak on 23/01/2020.
//  Copyright © 2020 Dominik Hażak. All rights reserved.
//

import Foundation

struct ServerResponse{
    var error: String?
    var message: String?
    var success: Bool?
    var appVersion: String?
    var data: [String:Any]?
    var dataArray: [Any]?
    
    init(_ object:[String:Any]){
        self.error = object["error"] as? String
        self.message = object["message"] as? String
        self.success = object["success"] as? Bool
        self.data = object["data"] as? [String:Any]
        self.dataArray = object["data"] as? [Any]
        self.appVersion = object["appVersion"] as? String
    }
}
