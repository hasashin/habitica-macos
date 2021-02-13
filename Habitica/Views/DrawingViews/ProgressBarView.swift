//
//  ProgressBarView.swift
//  Habitica
//
//  Created by Dominik Hażak on 16/05/2020.
//  Copyright © 2020 Dominik Hażak. All rights reserved.
//

import SwiftUI

struct ProgressBarView: View {
    let color: Color
    var width: CGFloat
    var height: CGFloat = 15
    var value: Int
    var maxValue: Int
    var body: some View {
        ZStack(alignment:.leading){
            Capsule()
                .fill(Color(red: 0.0, green: 0.01, blue: 0.2).opacity(0.2))
                .frame(width: width, height: height)
            Capsule()
                .fill(color.opacity(0.5))
                .frame(width: CGFloat(value*Int(width)/maxValue), height: height)
        }
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView(color: Color.red, width:100, height: 15, value: 30, maxValue: 50)
    }
}
