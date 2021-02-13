//
//  HabitRow.swift
//  Habitica
//
//  Created by Dominik Hażak on 30/01/2020.
//  Copyright © 2020 Dominik Hażak. All rights reserved.
//

import SwiftUI
import Foundation

struct TaskRow: View {
    let weekdays = ["Monday":"m", "Tuesday":"t", "Wednesday":"w", "Thursday":"th", "Friday":"f", "Saturday":"s", "Sunday":"su"]
    var currentTask:Task
    @Binding var errorMessage:String
    @Binding var showErrorAlert:Bool
    @State var completed = false
    var body: some View {
        HStack{
            if currentTask.type == .habit{
                VStack {
                    Button(action:scoreUp){
                        Text("+")
                    }
                    Text("+\(currentTask.counterUp ?? 0)")
                        .font(Font.custom("Arial", size: 11))
                }
                //.background(Color.red)
                Divider()
            }
            else{
                VStack{
                    Button(action: scoreTask){
                        if currentTask.completed{
                            Text("☑︎")
                        }
                        else {
                            Text("☐")
                        }
                    }
                    .disabled(currentTask.completed)
                    .disabled(disableToday())
                    //.buttonStyle()
                    //.background(Color.red)
                    Text(">> \(currentTask.streak ?? 0)")
                        .font(Font.custom("Arial", size: 11))
                }
                Divider()
            }
            if currentTask.completed{
                VStack{
                    Text(currentTask.text)
                        .font(.callout)
                        .foregroundColor(Color.gray)
                    Text(currentTask.notes ?? "")
                        .font(.caption)
                        .lineLimit(3)
                        .layoutPriority(1)
                        .foregroundColor(Color.gray)
                }
            }
            else{
                VStack(alignment: .leading){
                    Text(currentTask.text)
                        .font(.callout)
                    Text(currentTask.notes ?? "")
                        .font(.caption)
                        .lineLimit(3)
                        .layoutPriority(1)
                }
            }
            Spacer()
            if currentTask.type == .habit{
                Divider()
                VStack{
                    Button(action:scoreDown){
                        Text("-")
                    }
                    Text("-\(currentTask.counterDown ?? 0)")
                        .font(Font.custom("Arial", size: 11))
                }
                //.background(Color.red)
            }
        }
        .frame(minWidth:30, maxWidth:.infinity, minHeight: 50)
//        .onAppear(){
//            print(self.currentTask.text)
//            print(self.currentTask.completed)
//        }
    }
    
    func dupa(){
        print("dupa")
    }
    
    func scoreTask(){
        score(direction: .up)
    }
    
    func scoreUp(){
        score(direction: .up)
    }
    
    func scoreDown(){
        score(direction: .down)
    }
    
    func disableToday() -> Bool{
        let index = Calendar.current.component(.weekdayOrdinal, from: Date())-1
        let habiticaWeekday = weekdays[Calendar.current.weekdaySymbols[index]]!
        return !(currentTask.repeat_?[habiticaWeekday] ?? true)
    }
    
    func score(direction:ScoreDirection){
        let session = HttpSession.shared
        do{
            guard let request =
                session.authorizedRequest(url: HabiticaUrl.submit(currentTask.id,direction.rawValue), method: "POST") else {
                errorMessage = "Nie można zmienić stanu."
                showErrorAlert = true
                return
            }
            let jsonData = try JSONSerialization.data(withJSONObject: [], options: [])
            session.post(request: request, json: jsonData)
            if let error = session.error{
                errorMessage = "Nie można zmienić stanu. Błąd:" + error
                showErrorAlert = true
            }
        }
        catch{
            errorMessage = "Nie można zmienić stanu. Błąd:" + error.localizedDescription
            showErrorAlert = true
        }
        (NSApplication.shared.delegate as! AppDelegate).reloadTasks(self)
        (NSApplication.shared.delegate as! AppDelegate).reloadUser()
    }
    
    enum ScoreDirection : String{
        case up = "up"
        case down = "down"
        case none = ""
    }
}
