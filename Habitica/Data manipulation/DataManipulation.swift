//
//  DataManipulation.swift
//  Habitica
//
//  Created by Dominik Hażak on 14/02/2020.
//  Copyright © 2020 Dominik Hażak. All rights reserved.
//


#if !os(iOS)
import Cocoa
import SwiftUI

class DataManipulation{
    
    //private var innerTasks:Tasks
    private var http:HttpSession
    private let dataContext:NSManagedObjectContext
    public static var shared = DataManipulation(container:nil)
    
    init?(container:NSPersistentContainer?) {
        guard let container = container else {
            return nil
        }
        //_tasks = Tasks()
        http = HttpSession.shared
        dataContext = container.viewContext
    }
    
    @available(*, deprecated, message: "Temporary")
    public func showAllItems()->String{
        return get().description
    }
    
    public func getUserData() throws -> UserData?{
        guard let request = http.authorizedRequest(url: HabiticaUrl.user(["stats", "profile"]), method: "GET") else
        {
            throw DataError.common(message: "Couldn't create a request")
        }
        http.get(request: request)
        if let error = http.error {
            throw DataError.common(message: error)
        }
        
        guard let rawData = http.data?.data else {
            throw DataError.common(message: "No data recieved")
        }
        return UserData(from: rawData)
    }
    
    public func updateUserData( _ userData: inout UserData?) throws{
            userData = try getUserData()
    }
    
    public func updateTasks( _ tasks:inout [Task]){
        for object in get(){
            if let task = tasks.first(where: {elem in elem.id == (object.value(forKey: "id") as! String)}){
                if !equals(task, with: Task(from: object)) {
                    if let index = tasks.firstIndex(where: {elem in equals(elem, with: task)}){
                        tasks[index] = Task(from: object)
                        print("Podmieniłem xD")
                    }
//                    else{
//                        tasks.append(Task(from: object))
//                    }
                }
            }
            else{
                let task = Task(from: object)
                tasks.append(task)
            }
        }
    }
    
    public func updateObject(from task:Task) throws{
        let object = get(id: task.id)!
        updateManaged(object, from: task)
        try dataContext.save()
    }
    
    public func reloadTasks() throws {
        //print("reload tasks")
        guard let request = http.authorizedRequest(url: HabiticaUrl.tasks, method: "GET") else {
            return
        }
        http.get(request: request)
        if let error = http.error {
            throw DataError.common(message: error)
        }
        guard let recievedTasks = http.data?.dataArray else {
            throw DataError.common(message: "Brak danych")
        }
        
        for task in recievedTasks {
            if let task = task as? [String:Any]{
                if let object = get(id: task["id"] as! String){
                    updateManaged(object, from: task)
                }
                else{
                    let _ = createManaged(from: task)
                }
            }
            else {
                continue
            }
        }
    }
    
    public func clear() throws{
        for managed in get(){
            try delete(managed)
        }
    }
    
    private func delete(_ managed:NSManagedObject) throws{
        dataContext.delete(managed)
        try dataContext.save()
    }
    
    private func get(id:String) -> NSManagedObject?{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredTasks")
        request.predicate = NSPredicate(format: "id = %@", id)
        do{
            let result = try dataContext.fetch(request)
            if result.count > 0 {
                return result[0] as? NSManagedObject
            }
        }
        catch{
            print(error)
        }
        return nil
    }
    
    private func get(type:String) -> [NSManagedObject]{
        var objectArray = [NSManagedObject]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredTasks")
        request.predicate = NSPredicate(format: "type = %@", type)
        do{
            let result = try dataContext.fetch(request)
            objectArray.append(contentsOf: result as! [NSManagedObject])
        }
        catch{
            print(error)
        }
        return objectArray
    }
    
    private func get() -> [NSManagedObject]{
        var objectArray = [NSManagedObject]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredTasks")
        do{
            let result = try dataContext.fetch(request)
            objectArray.append(contentsOf: result as! [NSManagedObject])
        }
        catch{
            print(error)
        }
        return objectArray
    }
    
    private func createManaged(from task:Task) -> NSManagedObject{
        let entity = NSEntityDescription.entity(forEntityName: "StoredTasks", in: dataContext)
        let converted = NSManagedObject.init(entity: entity!, insertInto: dataContext)
        updateManaged(converted, from: task)
        return converted
    }
    
    private func createManaged(from json:[String:Any]) -> NSManagedObject{
        let entity = NSEntityDescription.entity(forEntityName: "StoredTasks", in: dataContext)
        let converted = NSManagedObject.init(entity: entity!, insertInto: dataContext)
        updateManaged(converted, from: json)
        return converted
    }
    
    private func updateManaged(_ object:NSManagedObject, from task:Task){
        object.setValue(task.id, forKey: "id")
        object.setValue(task.text, forKey: "text")
        object.setValue(task.type.rawValue, forKey: "type")
        object.setValue(task.tags, forKey: "tags")
        object.setValue(task.alias, forKey: "alias")
        object.setValue(task.attribute, forKey: "attribute")
        object.setValue(task.collapseChecklist, forKey: "collapseChecklist")
        object.setValue(task.notes, forKey: "notes")
        object.setValue(task.date, forKey: "date")
        object.setValue(task.priority, forKey: "priority")
        object.setValue(task.reminders, forKey: "reminders")
        object.setValue(task.frequency, forKey: "frequency")
        object.setValue(task.repeat_, forKey: "repeat_")
        object.setValue(task.everyX, forKey: "everyX")
        object.setValue(task.streak, forKey: "streak")
        object.setValue(task.daysOfMonth, forKey: "daysOfMonth")
        object.setValue(task.weeksOfMonth, forKey: "weeksOfMonth")
        object.setValue(task.startDate, forKey: "startDate")
        object.setValue(task.counterUp, forKey: "counterUp")
        object.setValue(task.counterDown, forKey: "counterDown")
        object.setValue(task.value, forKey: "value")
        object.setValue(task.completed, forKey: "completed")
    }
    
    private func updateManaged(_ object:NSManagedObject, from json:[String:Any]){
        object.setValue(json["id"] as! String, forKey: "id")
        object.setValue(json["text"] as! String, forKey: "text")
        object.setValue(json["type"] as! String, forKey: "type")
        object.setValue(json["tags"] as! [String], forKey: "tags")
        object.setValue(json["alias"] as? String, forKey: "alias")
        object.setValue(json["attribute"] as? String, forKey: "attribute")
        object.setValue(json["collapseChecklist"] as? Bool ?? true, forKey: "collapseChecklist")
        object.setValue(json["notes"] as? String, forKey: "notes")
        object.setValue(json["date"] as? String, forKey: "date")
        object.setValue(json["priority"] as! Float, forKey: "priority")
        object.setValue(json["reminders"] as! [Reminder], forKey: "reminders")
        object.setValue(json["frequency"] as? String, forKey: "frequency")
        object.setValue(json["repeat"] as? [String:Bool], forKey: "repeat_")
        object.setValue(json["everyX"] as? Int, forKey: "everyX")
        object.setValue(json["streak"] as? Int, forKey: "streak")
        object.setValue(json["daysOfMonth"] as? [Int], forKey: "daysOfMonth")
        object.setValue(json["weeksOfMonth"] as? [Int], forKey: "weeksOfMonth")
        object.setValue(json["startDate"] as? String, forKey: "startDate")
        object.setValue(json["counterUp"] as? Int, forKey: "counterUp")
        object.setValue(json["counterDown"] as? Int, forKey: "counterDown")
        object.setValue(json["value"] as? Float, forKey: "value")
        object.setValue(json["completed"] as? Bool ?? false, forKey: "completed")
    }
    
    private func updateTask(_ task:inout Task, from object:NSManagedObject){
        if task.id == object.value(forKey:"id") as! String {
            task.setValues(from: object)
            //print("object: \(object.value(forKey: "completed")), task: \(task.completed)")
        }
    }
    
    private func equals(_ first: Task, with second: Task) -> Bool{
        return  first.id == second.id &&
                first.text == second.text &&
                first.type == second.type &&
                first.tags == second.tags &&
                first.alias == second.alias &&
                first.attribute == second.attribute &&
                first.collapseChecklist == second.collapseChecklist &&
                first.notes == second.notes &&
                first.date == second.date &&
                first.priority == second.priority &&
                first.reminders == second.reminders &&
                first.frequency == second.frequency &&
                first.repeat_ == second.repeat_ &&
                first.everyX == second.everyX &&
                first.streak == second.streak &&
                first.daysOfMonth == second.daysOfMonth &&
                first.weeksOfMonth == second.weeksOfMonth &&
                first.startDate == second.startDate &&
                first.counterUp == second.counterUp &&
                first.counterDown == second.counterDown &&
                first.value == second.value &&
                first.completed == second.completed
    }
}

enum DataError : Error{
    case common(message:String)
}
#endif
