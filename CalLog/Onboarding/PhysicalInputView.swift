//
//  PhysicalInputView.swift
//  CalLog
//
//  Created by Shinhyuk Park on 8/22/24.
//

import SwiftUI

struct PhysicalInputView: View {
    
    @Binding var height: String
    @Binding var weight: String
    
    var body: some View {
        VStack(alignment:.leading,spacing: 15){
            Text("""
                키와 몸무게를
                     입력해주세요
                """)
            .font(.largeTitle)
            .bold()
            .padding()
            VStack(alignment:.leading){
                Text("키 (cm)")
                    .font(.headline)
                TextField("키를 입력하세요", text: $height)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(.systemGray6)).shadow(radius: 10))
            }
            .padding()
            VStack(alignment:.leading){
                Text("몸무게 (kg)")
                    .font(.headline)
                TextField("몸무게를 입력하세요", text: $weight)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(.systemGray6)).shadow(radius: 10))
            }
            .padding()
        }
        .padding()
    }
}

//#Preview {
//    PhysicalInputView()
//}
