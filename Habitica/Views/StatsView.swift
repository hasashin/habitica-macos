//
//  StatsView.swift
//  Habitica
//
//  Created by Dominik Hażak on 16/05/2020.
//  Copyright © 2020 Dominik Hażak. All rights reserved.
//

import SwiftUI

struct StatsView: View {
    let http = HttpSession.shared
    @Binding var errorMessage: String
    @Binding var showErrorAlert: Bool
    @EnvironmentObject var user: UserData
    var body: some View {
        VStack{
            HStack{
                Image("background_\(user.prefs.Background ?? "yellow")")
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .leading)
                Spacer()
                VStack{
                    
                    HStack{
                        VStack{
                            Image("health")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Spacer()
                        }
                        VStack{
                            GeometryReader{geometry in
                                self.drawBar(color: Color.red, value: Int(user.stats.hp ?? 0), maxValue: 50, width: geometry.size.width, height: geometry.size.height*2)
                            }
                            HStack{
                                Text("\(Int(user.stats.Hp))/50")
                                Spacer()
                                Text("Health")
                            }
                        }
                    }
                    HStack{
                        VStack{
                            Image("experience")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Spacer()
                        }
                        VStack{
                            GeometryReader{geometry in
                                self.drawBar(color: Color.yellow, value: Int(user.stats.exp ?? 0), maxValue: user.calculateMaxExp(), width: geometry.size.width, height: geometry.size.height*2)
                            }
                            HStack{
                                Text("\(Int(user.stats.exp ?? 0))/\(user.calculateMaxExp())")
                                Spacer()
                                Text("Experience")
                            }
                        }
                    }
                    HStack{
                        VStack{
                            Image("mana")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Spacer()
                        }
                        VStack{
                            GeometryReader{geometry in
                                self.drawBar(color: Color.blue, value: Int(user.stats.mp ?? 0), maxValue: user.calculateMaxMana(), width: geometry.size.width, height: geometry.size.height*2)
                            }
                            HStack{
                                Text("\(Int(user.stats.Mp))/\(user.stats.calculateMaxMana())")
                                Spacer()
                                Text("Mana")
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            
            HStack{
                Image("black_yellow_shield_outline")
                    .resizable()
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading){
                    Text("\(user.profile["name"] ?? "[profilename]")")
                    Text("Level \(user.stats.lvl ?? -1) \(user.stats.clas ?? "[classname]")")
                }
                Spacer()
                Image("gem")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("\(Int(user.stats.points ?? -1))")
                Image("gold")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("\(Int(user.stats.gp ?? -1))")
            }
            .padding(.horizontal)
        }
        .frame(minWidth: 380, maxWidth: .infinity, minHeight: 150, maxHeight: .infinity, alignment: .center)
    }
    
    func drawBar(color:Color, value:Int, maxValue: Int, width:CGFloat, height: CGFloat=15) -> some View{
        return ProgressBarView(color: color, width: width, height: height, value: value, maxValue: maxValue)
    }
    
    func showAlert(with message: String){
        errorMessage = message
        showErrorAlert = true
    }
    func updateStats(){
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
}
