//
//  ContentView.swift
//  Habitica
//
//  Created by Dominik Hażak on 23/01/2020.
//  Copyright © 2020 Dominik Hażak. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    let loginData:NSPersistentContainer
    let jsonDecoder = JSONDecoder()
    let jsonEncoder = JSONEncoder()
    let session = URLSession.shared
    let http = HttpSession.shared
    let group = DispatchGroup()
    @State var isLogged = false
    @State var showErrorAlert = false
    @State var errorMessage = ""
    @State var username = ""
    @State var pass = ""
    @State var saveLoginData = false
    var body: some View {
        VStack{
            Text("Habitica login")
                .frame(width: 200, height: 50, alignment: .leading)
            TextField("Login", text: $username)
                .frame(width: 200, height: 50, alignment: .leading)
            SecureField("Hasło", text: $pass)
                .frame(width: 200, height: 50, alignment: .leading)
            Toggle(isOn: $saveLoginData){
                Text("Zapisz moje dane")
            }
            Button(action: doLogin){
                Text("Loguj")
            }
        }
        .frame(width: 300, height: 400, alignment: .top)
        .sheet(isPresented: $showErrorAlert){
            WarningView(title: "Błąd", message: self.errorMessage, button1: (Text("OK"), self.dismissSheet))
        }
        .padding()
        .onAppear(perform: loginStoredAccount)
    }
    
    func dismissSheet(){
        self.showErrorAlert = false
    }
    
    func loginStoredAccount(){
        guard let stored = getStoredAccount() else {
            return
        }
        username = stored.value(forKey: "login") as! String
        pass = stored.value(forKey: "password") as! String
        doLogin()
    }
    
    func getStoredAccount() -> NSManagedObject? {
        print("loginStoredAccount")
        do{
            let data = try loginData.viewContext.fetch(NSFetchRequest<NSManagedObject>(entityName: "Login"))
            guard data.count > 0 else{
                return nil
            }
            return data[0]
        }
        catch{
            errorMessage = "Nie można było wczytać konta, zaloguj się ponownie."+error.localizedDescription
            showErrorAlert = true
        }
        return nil
    }
    
    func doLogin(){
        do{
            if try http.login(login: username, password: pass) {
                guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else{
                    self.errorMessage = "Cannot change contentView"
                    self.showErrorAlert = true
                    return
                }
                if saveLoginData{
                    saveAccountToDataModel()
                }
                appDelegate.changeContentView(newContent: AnyView(MainView()))
            }
            else {
                self.errorMessage = http.error ?? "Didn't get any message"
                self.showErrorAlert = true
            }
        }
        catch{
            self.errorMessage = error.localizedDescription
            self.showErrorAlert = true
        }
    }
    
    func saveAccountToDataModel(){
        let managedContext = loginData.viewContext
        var login:NSManagedObject
        
        if let stored = getStoredAccount(){
            login = stored
        }
        else{
            let entity = NSEntityDescription.entity(forEntityName: "Login", in: managedContext)!
        
            login = NSManagedObject(entity: entity, insertInto: managedContext)
        }
        login.setValue(username, forKey: "login")
        login.setValue(pass, forKey: "password")
        do{
            try managedContext.save()
        }
        catch{
            errorMessage = "Nie można zapisać hasła. Błąd: "+error.localizedDescription
            showErrorAlert = true
        }
    }
}
