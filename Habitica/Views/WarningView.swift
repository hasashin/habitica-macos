//
//  WarningView.swift
//  Habitica
//
//  Created by Dominik Hażak on 03/02/2020.
//  Copyright © 2020 Dominik Hażak. All rights reserved.
//

import SwiftUI

struct WarningView : View{

    let title:String
    let message:String
    let buttons:AnyView
    
    init(title:String, message:String, button1:(Label:Text, Action:()->Void)) {
        self.title = title
        self.message = message
        buttons = AnyView(
            HStack{
                Spacer()
                Button(action:button1.Action){button1.Label}
            }
        )
    }
    init(title:String, message:String, button1:(Label:Text, Action:()->Void), button2:(Label:Text, Action:()->Void)) {
        self.title = title
        self.message = message
        buttons = AnyView(
            HStack{
                Spacer()
                Button(action:button1.Action){button1.Label}
                Button(action:button2.Action){button2.Label}
            }
        )
    }

    var body : some View {
        VStack{
            Text(title)
                .font(.headline)
                .frame(alignment: .leading)
            Text(message)
            buttons

        }
        .frame(width: 300, alignment: .leading)
        .padding()
    }
}

