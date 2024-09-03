//
//  MeView.swift
//  CalLog
//
//  Created by Shinhyuk Park on 8/3/24.
//

import SwiftUI

struct MeView: View {
    
    @EnvironmentObject var myModel: MyModel
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationStack{
            Divider()
            ProfileView()
                .padding(.bottom, 50)
                .navigationTitle("내 정보")
                .toolbar{
                    ToolbarItem {
                        Button{
                            showingEditProfile = true
                        }label: {
                            Image(systemName: "square.and.pencil")
                        }
                    }
                }
                .sheet(isPresented: $showingEditProfile, content: {
                    ProfileEditView()
            })
        }
    }
}


#Preview {
    MeView().environmentObject(MyModel())
}
