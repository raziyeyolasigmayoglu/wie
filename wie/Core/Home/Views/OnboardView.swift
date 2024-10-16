//
//  OnboardView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 26/10/2023.
//

import SwiftUI

struct OnboardView: View {
    
    
    @EnvironmentObject private var vm: HomeViewModel
    @EnvironmentObject var userProgress: UserProgress
    @State private var isFilled = false
    let menuItems = Menu.options
    
    var body: some View {
        VStack(spacing: 0) {
            header
                .padding()
            //.frame(maxWidth: maxWidthForIpad)
            menu
        }
        
    }
    
    private var menu: some View {
        List (menuItems) { item in
            ZStack{
                CustomNavLinkView(destination: destinationView(selectedId: item.id)) {EmptyView()}
                    .opacity(0.0)
                menuItemView(item)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.theme.background)
        }
        .listStyle(PlainListStyle())
    }
    
    private func menuItemView(_ item: MenuItem) -> some View {
        ZStack(alignment: .leading) {
            Image("\(item.id)")
                .resizable()
                .scaledToFill()
                .overlay(
                    heartIconOverlay,
                    alignment: .topTrailing
                )
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
            
            Text(item.title)
                .font(.custom("ChalkboardSE-Regular", size: 30))
            //.fontWeight(.semibold)
                .foregroundColor(Color.theme.accent)
                .multilineTextAlignment(.leading)
                .frame(alignment: .leading)
                .padding(.leading, 115)
                .padding(.top, item.id == 1 ? 42 : 15)
                .padding(.trailing, item.id == 1 ? 10 : 0)
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
    }
    
    private var heartIconOverlay: some View {
        Image(systemName: isFilled ? "heart.fill" : "heart")
            .font(.system(size: 25))
            .padding()
            .foregroundColor(Color.theme.accent)
            .background(
                Circle()
                    .fill(Color.theme.yellow.opacity(0.2)))
            .padding(8)
            .onTapGesture {
                isFilled.toggle()
            }
    }
    
    private func destinationView(selectedId: Int) -> some View {
        switch selectedId {
        case 1:
            return AnyView(CommonExceptionWordsView()
                .customNavigationTitle("Common Exception Words")
                .environmentObject(vm)
                .environmentObject(UserProgress.shared)
            )
            
        case 2:
            return AnyView(WhatsOnTheTrayView()
                .customNavigationTitle("What's on the Tray")
                .environmentObject(vm)
                .environmentObject(UserProgress.shared)
            )
        case 3:
            return AnyView(WordSearchView()
                .customNavigationTitle("Word Search")
                .environmentObject(vm)
                .environmentObject(UserProgress.shared)
            )
        default:
            return AnyView(Text("Default View"))
        }
    }
}

struct Previews_OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView()
            .environmentObject(HomeViewModel())
            .environmentObject(UserProgress.shared)
    }
}


extension OnboardView {
    private var header: some View {
        VStack {
            Button(action: vm.toogleWordsList) {
                Text(vm.currentWordLevel.name)
                    .font(.custom("ChalkboardSE-Regular", size: 24))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.theme.accent)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.theme.accent)
                            .padding()
                            .rotationEffect(Angle(degrees: vm.showWordsList ? 180 : 0))
                    }
            }
            
            if vm.showWordsList {
                WordLevelsView().environmentObject(vm)
            }
            
        }
        .background(Color.theme.fillingColor)
        .cornerRadius(20)
        .shadow(color: Color.theme.fillingColor.opacity(0.5), radius: 20, x: 0, y: 15)
        
    }
}
