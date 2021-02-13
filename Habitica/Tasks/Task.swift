//
//  Habit.swift
//  Habitica
//
//  Created by Dominik Hażak on 23/01/2020.
//  Copyright © 2020 Dominik Hażak. All rights reserved.
//

#if !os(iOS)
import Cocoa
#endif
import SwiftUI

struct Task : Identifiable{
    init(from object:NSManagedObject){
        self.id = object.value(forKey: "id") as! String
        self.text = object.value(forKey: "text") as! String
        self.type = TaskType(rawValue: object.value(forKey: "type") as! String)!
        self.tags = object.value(forKey: "tags") as! [String]
        self.alias = object.value(forKey: "alias") as? String
        self.attribute = object.value(forKey: "attribute") as? String
        self.collapseChecklist = object.value(forKey: "collapseChecklist") as! Bool
        self.notes = object.value(forKey: "notes") as? String
        self.date = object.value(forKey: "date") as? String
        self.priority = object.value(forKey: "priority") as! Float
        self.reminders = object.value(forKey: "reminders") as! [Reminder]
        self.frequency = object.value(forKey: "frequency") as? String
        self.repeat_ = object.value(forKey: "repeat_") as? [String:Bool]
        self.everyX = object.value(forKey: "everyX") as? Int
        self.streak = object.value(forKey: "streak") as? Int
        self.daysOfMonth = object.value(forKey: "daysOfMonth") as? [Int]
        self.weeksOfMonth = object.value(forKey: "weeksOfMonth") as? [Int]
        self.startDate = object.value(forKey: "startDate") as? String
        self.counterUp = object.value(forKey: "counterUp") as? Int
        self.counterDown = object.value(forKey: "counterDown") as? Int
        self.value = object.value(forKey: "value") as? Float
        self.completed = object.value(forKey: "completed") as! Bool
    }
    var id:String
    var text:String
    var type:TaskType
    var tags:[String]
    var alias:String?
    var attribute:String?
    var collapseChecklist:Bool
    var notes:String?
    
    //only when type = .todo
    var date:String?
    
    //equivalent of trivial, easy, medium, hard
    //allowed values "0.1", "1", "1.5", "2"
    var priority:Float
    
    var reminders:[Reminder]
    
    //only when type = .daily
    var frequency:String?
    var repeat_:[String:Bool]?
    var everyX:Int?
    var streak:Int?
    var daysOfMonth:[Int]?
    var weeksOfMonth:[Int]?
    var startDate:String?
    
    //only when type .habit
    var counterUp: Int?
    var counterDown: Int?
    
    //only when type = .reward
    var value:Float?
    
    //only for todo and daily
    var completed:Bool = false
    
    mutating func setValues(from object:NSManagedObject){
        self.id = object.value(forKey: "id") as! String
        self.text = object.value(forKey: "text") as! String
        self.type = TaskType(rawValue: object.value(forKey: "type") as! String)!
        self.tags = object.value(forKey: "tags") as! [String]
        self.alias = object.value(forKey: "alias") as? String
        self.attribute = object.value(forKey: "attribute") as? String
        self.collapseChecklist = object.value(forKey: "collapseChecklist") as! Bool
        self.notes = object.value(forKey: "notes") as? String
        self.date = object.value(forKey: "date") as? String
        self.priority = object.value(forKey: "priority") as! Float
        self.reminders = object.value(forKey: "reminders") as! [Reminder]
        self.frequency = object.value(forKey: "frequency") as? String
        self.repeat_ = object.value(forKey: "repeat_") as? [String:Bool]
        self.everyX = object.value(forKey: "everyX") as? Int
        self.streak = object.value(forKey: "streak") as? Int
        self.daysOfMonth = object.value(forKey: "daysOfMonth") as? [Int]
        self.weeksOfMonth = object.value(forKey: "weeksOfMonth") as? [Int]
        self.startDate = object.value(forKey: "startDate") as? String
        self.counterUp = object.value(forKey: "counterUp") as? Int
        self.counterDown = object.value(forKey: "counterDown") as? Int
        self.value = object.value(forKey: "value") as? Float
        self.completed = object.value(forKey: "completed") as! Bool
    }
    
}

//class NoTask{
//    init(
//        id:String,
//        text:String,
//        type:TaskType,
//        tags:[String],
//        alias:String?,
//        attribute:String?,
//        collapseChecklist:Bool,
//        notes:String?,
//        date:String?,
//        priority:Float,
//        reminders:[Reminder],
//        frequency:String?,
//        _repeat:[String:Any]?,
//        everyX:Int?,
//        streak:Int?,
//        daysOfMonth:[Int]?,
//        weeksOfMonth:[Int]?,
//        startDate:String?,
//        counterUp:Int?,
//        counterDown:Int?,
//        value:Float?,
//        completed:Bool
//    ){
//        self.id = id
//        self.text = text
//        self.type = type
//        self.tags = tags
//        self.alias = alias
//        self.attribute = attribute
//        self.collapseChecklist = collapseChecklist
//        self.notes = notes
//        self.date = date
//        self.priority = priority
//        self.reminders = reminders
//        self.frequency = frequency
//        self._repeat = _repeat
//        self.everyX = everyX
//        self.streak = streak
//        self.daysOfMonth = daysOfMonth
//        self.weeksOfMonth = weeksOfMonth
//        self.startDate = startDate
//        self.counterUp = counterUp
//        self.counterDown = counterDown
//        self.value = value
//        self.completed = completed
//    }
//    init(){
//        self.id = ""
//        self.text = ""
//        self.type = .todo
//        self.tags = []
//        self.alias = nil
//        self.attribute = nil
//        self.collapseChecklist = true
//        self.notes = nil
//        self.date = nil
//        self.priority = 0
//        self.reminders = []
//        self.frequency = nil
//        self._repeat = nil
//        self.everyX = nil
//        self.streak = nil
//        self.daysOfMonth = nil
//        self.weeksOfMonth = nil
//        self.startDate = nil
//        self.counterUp = nil
//        self.counterDown = nil
//        self.value = nil
//        self.completed = false
//    }
//    var id:String
//    var text:String
//    var type:TaskType
//    var tags:[String]
//    var alias:String?
//    var attribute:String?
//    var collapseChecklist:Bool
//    var notes:String?
//
//    //only when type = .todo
//    var date:String?
//
//    //equivalent of trivial, easy, medium, hard
//    //allowed values "0.1", "1", "1.5", "2"
//    var priority:Float
//
//    var reminders:[Reminder]
//
//    //only when type = .daily
//    var frequency:String?
//    var _repeat:[String:Bool]?
//    var everyX:Int?
//    var streak:Int?
//    var daysOfMonth:[Int]?
//    var weeksOfMonth:[Int]?
//    var startDate:String?
//
//    //only when type .habit
//    var counterUp: Int?
//    var counterDown: Int?
//
//    //only when type = .reward
//    var value:Float?
//
//    //only for todo and daily
//    @State var completed:Bool
//
//    func setValues(
//        id:String,
//        text:String,
//        type:TaskType,
//        tags:[String],
//        alias:String?,
//        attribute:String?,
//        collapseChecklist:Bool,
//        notes:String?,
//        date:String?,
//        priority:Float,
//        reminders:[Reminder],
//        frequency:String?,
//        _repeat:[String:Bool]?,
//        everyX:Int?,
//        streak:Int?,
//        daysOfMonth:[Int]?,
//        weeksOfMonth:[Int]?,
//        startDate:String?,
//        counterUp:Int?,
//        counterDown:Int?,
//        value:Float?,
//        completed:Bool
//    ){
//        self.id = id
//        self.text = text
//        self.type = type
//        self.tags = tags
//        self.alias = alias
//        self.attribute = attribute
//        self.collapseChecklist = collapseChecklist
//        self.notes = notes
//        self.date = date
//        self.priority = priority
//        self.reminders = reminders
//        self.frequency = frequency
//        self._repeat = _repeat
//        self.everyX = everyX
//        self.streak = streak
//        self.daysOfMonth = daysOfMonth
//        self.weeksOfMonth = weeksOfMonth
//        self.startDate = startDate
//        self.counterUp = counterUp
//        self.counterDown = counterDown
//        self.value = value
//        self.completed = completed
//    }
//}

enum TaskType: String{
    case habit = "habit"
    case daily = "daily"
    case todo = "todo"
    case reward = "reward"
}
