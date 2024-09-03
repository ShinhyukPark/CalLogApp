//
//  WelcomeView.swift
//  CalLog
//
//  Created by Shinhyuk Park on 8/21/24.
//

import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        VStack{
            Image("welcome")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .shadow(radius: 5)
            Text("""
                    칼로리를 관리하고,
                    건강한 습관을 만들어보세요.
                    """)
            .font(.title)
        }
    }
}

#Preview {
    WelcomeView()
}
