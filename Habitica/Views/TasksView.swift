//
//  TasksView.swift
//  Habitica
//
//  Created by Dominik Hażak on 23/01/2020.
//  Copyright © 2020 Dominik Hażak. All rights reserved.
//

import SwiftUI

struct TasksView: View {
    @EnvironmentObject var tasks:Tasks
    var filter:TaskType
    @Binding var errorMessage:String
    @Binding var showErrorAlert:Bool
    var body: some View {
        ScrollView{
            VStack{
                ForEach(tasks.taskList.filter {$0.type == filter}.sorted(by: {first, second in first.text < second.text})){task in
                    VStack{
                        Divider()
                        TaskRow(currentTask: task, errorMessage: self.$errorMessage, showErrorAlert: self.$showErrorAlert)
                    }
                }
                Divider()
            }
        }
    }
}
