//
//  DebugView.swift
//  Habitica
//
//  Created by Dominik Hażak on 09/03/2020.
//  Copyright © 2020 Dominik Hażak. All rights reserved.
//

import Foundation
import SwiftUI

struct DebugView:View{
    let info:String
    
    var body: some View{
        ScrollView{
            Text(info)
        }
        .frame(width: 300, height: 400, alignment: .top)
    }
}
