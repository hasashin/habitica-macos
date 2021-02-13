//
//  AppDelegate.swift
//  Habitica
//
//  Created by Dominik Hażak on 23/01/2020.
//  Copyright © 2020 Dominik Hażak. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!
    
    @ObservedObject var tasks = Tasks()
    @State var errorMessage:String = ""
    @State var showErrorAlert:Bool = false
    @ObservedObject var user:UserData? = DataManipulation.shared?.getUserData()
    
    @IBAction func hardReloadTasks(_ sender: Any) {
        tasks.doHardReload()
    }
    @IBAction func reloadTasks(_ sender: Any) {
        do{
            try tasks.doReload()
        }
        catch{}
    }
    
    func reloadUser(){
        do{
            try DataManipulation.shared?.updateUserData(&userData)
        }
        catch{}
    }
    
    @IBAction func showDebugWindow(_ sender: NSMenuItem) {
        
        let debugView = DebugView(info: DataManipulation.shared!.showAllItems())
        
        let debug_window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
        styleMask: [.titled, .closable, .fullSizeContentView, .resizable],
        backing: .buffered, defer: false)
        debug_window.center()
        debug_window.setFrameAutosaveName("Debug information")
        debug_window.contentView = NSHostingView(rootView: debugView)
        debug_window.makeKeyAndOrderFront(window)
    }
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Habitica")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create HTTPSession
        DataManipulation.shared = DataManipulation(container: persistentContainer)
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = LoginView(loginData: persistentContainer)
        
        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 400),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Habitica")
        window.contentView = NSHostingView(rootView: contentView)
        window.isReleasedWhenClosed = false
        window.makeKeyAndOrderFront(nil)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func loginUser(username:String, password:String){
        
    }
    
    func changeContentView(newContent: AnyView){
        self.window.close()
        self.window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 380, height: 500),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        self.window.center()
        self.window.setFrameAutosaveName("Habitica")
        self.window.contentView = NSHostingView(rootView: newContent.environmentObject(user).environmentObject(tasks))
        self.window.isReleasedWhenClosed = false
        self.window.makeKeyAndOrderFront(nil)
        //self.window.contentView = NSHostingView(rootView: newContent.environmentObject(tasks))
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool { 
        window.makeKeyAndOrderFront(nil)
        return true
    }
    
    
}

