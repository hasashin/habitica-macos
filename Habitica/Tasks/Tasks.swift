//
//  Tasks.swift
//  Habitica
//
//  Created by Dominik Hażak on 03/02/2020.
//  Copyright © 2020 Dominik Hażak. All rights reserved.
//

import Foundation

class Tasks: ObservableObject {
    @Published var taskList: [Task]
    
    func doUpdate(){
        DataManipulation.shared!.updateTasks(&taskList)
    }
    
    func doReload() throws{
        try DataManipulation.shared!.reloadTasks()
        doUpdate()
    }
    
    func doHardReload(){
        do{
            try DataManipulation.shared!.clear()
            try DataManipulation.shared!.reloadTasks()
            taskList = []
            doUpdate()
        }
        catch {
            print(error)
        }
    }
    
//    func filteredList(type: TaskType) -> [Task] {
//        return taskList.filter {$0.type == type}
//    }
    
    init() {
        self.taskList = []
    }
}
