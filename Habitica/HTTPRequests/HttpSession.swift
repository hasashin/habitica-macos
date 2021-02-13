//
//  Http.swift
//  Habitica
//
//  Created by Dominik Hażak on 30/01/2020.
//  Copyright © 2020 Dominik Hażak. All rights reserved.
//

import Foundation

class HttpSession {
    public private(set) var loggedIn:Bool = false
    public private(set) var apiToken:String? = nil
    public private(set) var userToken:String? = nil
    public private(set) var clientToken:String? = nil
    public private(set) var username:String? = nil
    private let session = URLSession.shared
    private let group = DispatchGroup()
    private var sessionData:(error:String?, data:ServerResponse?) = (nil, nil)
    
    public var data:ServerResponse? {
        get{
            return sessionData.data
        }
    }
    
    public var error:String? {
        get{
            return sessionData.error
        }
    }
    
    public static var shared:HttpSession = HttpSession()
    
    private func decodeJson(from data:Data) throws -> ServerResponse?{
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            else {
                return nil
        }
        return ServerResponse(json)
    }
    
    private func codeJson(with data:Any) throws -> Data? {
        try? JSONSerialization.data(withJSONObject: data, options: [])
    }
    
    public func login(login:String, password: String) throws -> Bool{
        var request = URLRequest(url: HabiticaUrl.login)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        guard let jsonData = try codeJson(with: ["username":login, "password": password]) else {
            sessionData = ("Could not create login message", nil)
            return false
        }
        
        post(request: request, json: jsonData)
        
        if let _ = sessionData.error {
            return false
        }
        
        guard
            let loginDataRaw = sessionData.data?.data,
            let loginData = LoginData(from: loginDataRaw)
            else{
                sessionData = ("Could not get login data", nil)
                return false
        }
        
        apiToken = loginData.apiToken
        userToken = loginData.id
        username = loginData.username
        clientToken = "ecd44f51-7295-4954-90b7-494b64d58dcf-HabiticaMacosClient"
        loggedIn = true
        return true
    }
    
    private func handleHTTPError(data:Data, response:HTTPURLResponse) -> String{
        var errorMessage:String
        switch response.statusCode{
            case 401:
                if let response = try? decodeJson(from: data){
                    errorMessage = response.message ?? "Wystąpił błąd"
                }
                else{
                    errorMessage = "Wystąpił błąd podczas dekodowania wiadomości"
            }
            default:
                errorMessage = "Got unhandled response code \(response.statusCode)"
                break
        }
        return errorMessage
    }
    
    private func requestHandler(data:Data?, response:URLResponse?, error:Error?) {
        var errorMessage:String
        
        if let error = error {
            errorMessage = error.localizedDescription
            sessionData = (errorMessage,nil)
            self.group.leave()
            return
        }
        
        guard let data = data, let response = response as? HTTPURLResponse else {
            errorMessage = "Didn't get any data. Is the connection working?"
            sessionData = (errorMessage, nil)
            self.group.leave()
            return
        }
        
        guard (200...299).contains(response.statusCode) else {
            let message = self.handleHTTPError(data: data, response: response)
            sessionData = (message, nil)
            self.group.leave()
            return
        }
        
        guard let responseData = try? decodeJson(from: data) else {
            sessionData = ("Could not decode response",nil)
            return
        }
        sessionData = (nil, responseData)
        group.leave()
    }
    
    public func post(request: URLRequest, json:Data){
        group.enter()
        let postTask = session.uploadTask(with: request, from: json, completionHandler: requestHandler)
        postTask.resume()
        group.wait()
    }
    
    public func get(request: URLRequest){
        group.enter()
        let getTask = session.dataTask(with: request, completionHandler: requestHandler)
        getTask.resume()
        group.wait()
    }
    
    public func authorizedRequest(url:URL, method:String) -> URLRequest? {
        
        if loggedIn{
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(userToken!, forHTTPHeaderField: "x-api-user")
            request.addValue(apiToken!, forHTTPHeaderField: "x-api-key")
            request.addValue(clientToken!, forHTTPHeaderField: "x-client")
            request.httpMethod = method
            return request
        }
        else {
            return nil
        }
    }
}
