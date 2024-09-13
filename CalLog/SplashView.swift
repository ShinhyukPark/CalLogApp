//
//  SplashView.swift
//  CalLog
//
//  Created by Shinhyuk Park on 9/5/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack{
            Color("SplashColor").ignoresSafeArea()
            Image("SplashImgae")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:150, height: 150)
        }
    }
}

#Preview {
    SplashView()
}
