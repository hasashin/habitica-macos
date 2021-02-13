//
//  MainView.swift
//  Habitica
//
//  Created by Dominik Hażak on 23/01/2020.
//  Copyright © 2020 Dominik Hażak. All rights reserved.
//

import SwiftUI

struct MainView:View{
    @State var showErrorAlert = false
    @State var errorMessage = ""
    @State var selectedTab:Tab = .habits
    @EnvironmentObject var user:UserData
    @EnvironmentObject var tasks:Tasks
    let http = HttpSession.shared
    var body: some View{
        VStack(alignment: .center){
            StatsView(errorMessage: $errorMessage, showErrorAlert: $showErrorAlert)
                .frame(height: 150)
                .padding(.top)
            Spacer()
            TabView(selection: $selectedTab){
                TasksView(filter: .habit, errorMessage: $errorMessage, showErrorAlert: $showErrorAlert)
                    .tabItem{
                        Text("Nawyki")
                    }
                    .tag(Tab.habits)
                .environmentObject(tasks)
                TasksView(filter: .daily, errorMessage: $errorMessage, showErrorAlert: $showErrorAlert)
                    .tabItem{
                        Text("Codzienne")
                    }
                    .tag(Tab.dailies)
                .environmentObject(tasks)
                TasksView(filter: .todo, errorMessage: $errorMessage, showErrorAlert: $showErrorAlert)
                    .tabItem{
                        Text("Do zrobienia")
                    }
                    .tag(Tab.todos)
                .environmentObject(tasks)
            }
            .padding(.horizontal)
            .sheet(isPresented: $showErrorAlert){
                WarningView(title: "Błąd", message: self.errorMessage, button1: (Text("OK"), self.dismissSheet))
            }
            .transition(.opacity)
            .onAppear {
                do{
                    try self.tasks.doReload()
                    try user.update()
                }
                catch DataError.common(let message){
                    self.errorMessage = message
                    self.showErrorAlert = true
                }
                catch{
                    print(error)
                }
            }
            .frame(minHeight: 350, maxHeight: .infinity)
            .touchBar{
                Spacer()
                createPicker()
                Spacer()
                compactStats()
            }
            
            Spacer()
            
        }
    }
    
    
    func dismissSheet(){
        self.showErrorAlert = false
    }
    
    func showAlert(with message: String){
        errorMessage = message
        showErrorAlert = true
    }
    
    func reloadTasks(){
        do{
            try DataManipulation.shared!.reloadTasks()
        }
        catch{
            showAlert(with: error.localizedDescription)
        }
    }
    
    func reloadUser(){
        do{
            try user.update()
        }
        catch DataError.common(let message){
            showAlert(with: message)
        }
        catch{
            print(error)
        }
    }
    
    func createPicker() -> some View{
        Picker("", selection: $selectedTab) {
            Text("Nawyki")
                .padding()
                .tag(Tab.habits)
                .frame(minWidth: 10)
            Text("Codzienne")
                .padding()
                .tag(Tab.dailies)
                .frame(minWidth: 10)
            Text("Do zrobienia")
                .padding()
                .tag(Tab.todos)
                .frame(minWidth: 10)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    func compactStats() -> some View{
        HStack{
            Image("health")
                .resizable()
                .frame(width: 20, height: 20)
            Text("\(Int(user.stats.hp ?? 0))/50")
                .foregroundColor(Color.red)
            Image("experience")
                .resizable()
                .frame(width: 20, height: 20)
            Text("\(Int(user.stats.exp ?? 0))/\(user.calculateMaxExp())")
                .foregroundColor(Color.yellow)
            Image("mana")
                .resizable()
                .frame(width: 20, height: 20)
            Text("\(Int(user.stats.mp ?? 0))/\(user.calculateMaxMana())")
                .foregroundColor(Color.blue)
        }
    }
}


extension MainView {
    enum Tab: Hashable {
        case habits
        case dailies
        case todos
    }
}
