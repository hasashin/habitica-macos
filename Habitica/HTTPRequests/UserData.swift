//
//  UserData.swift
//  Habitica
//
//  Created by Dominik Hażak on 16/05/2020.
//  Copyright © 2020 Dominik Hażak. All rights reserved.
//

import Foundation

class UserData: ObservableObject{
    @Published var preferences: UserPreferences
    @Published var profile: [String:String]
    @Published var stats: UserStats
    init?(from data:[String:Any]){
        guard
            let preferences = UserPreferences(from: data["preferences"] as? [String:Any]),
            let profile = data["profile"] as? [String:String],
            let stats = UserStats(from: data["stats"] as? [String:Any])
        else{
            return nil
        }
        self.preferences = preferences
        self.profile = profile
        self.stats = stats
    }
}

struct UserPreferences{
    let hair: [String:Any]
    let skin: String
    let shirt: String
    let language: String
    let background: String
    
    init?(from data:[String:Any]?){
        if let data = data{
            guard
                let hair = data["hair"] as? [String:Any],
                let skin = data["skin"] as? String,
                let shirt = data["shirt"] as? String,
                let language = data["language"] as? String,
                let background = data["background"] as? String
            else{
                return nil
            }
            self.hair = hair
            self.skin = skin
            self.shirt = shirt
            self.language = language
            self.background = background
        }
        else {
            return nil
        }
    }
}

struct UserStats {
    let hp: Double
    let mp: Double
    let exp: Int
    let gp: Double
    let lvl: Int
    let clas: String
    let points: Int
    let str: Int
    let con: Int
    let int: Int
    let per: Int
    
    init? (from data:[String:Any]?){
        if let data = data{
            guard
                let hp = data["hp"] as? Double,
                let mp = data["mp"] as? Double,
                let exp = data["exp"] as? Int,
                let gp = data["gp"] as? Double,
                let lvl = data["lvl"] as? Int,
                let clas = data["class"] as? String,
                let points = data["points"] as? Int,
                let str = data["str"] as? Int,
                let con = data["con"] as? Int,
                let int = data["int"] as? Int,
                let per = data["per"] as? Int
            else {
                return nil
            }
            
            self.hp = hp
            self.mp = mp
            self.exp = exp
            self.gp = gp
            self.lvl = lvl
            self.clas = clas
            self.points = points
            self.str = str
            self.con = con
            self.int = int
            self.per = per
        }
        else{
            return nil
        }
    }
}
