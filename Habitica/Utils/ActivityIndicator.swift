//
//  ActivityIndicator.swift
//  Habitica
//
//  Created by Dominik Hażak on 23/01/2020.
//  Copyright © 2020 Dominik Hażak. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: View{
    @State var spinCircle = false
    var color:Color?

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.5, to: 1)
                .stroke(color ?? Color.blue, lineWidth:4)
                .frame(width:100)
                .rotationEffect(.degrees(spinCircle ? 0 : -360), anchor: .center)
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
        }
        .onAppear {
            self.spinCircle = true
        }
    }
}
