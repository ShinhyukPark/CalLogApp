//
//  AgeGenderSetupView.swift
//  CalLog
//
//  Created by Shinhyuk Park on 8/27/24.
//

import SwiftUI

struct AgeGenderSetupView: View {
    
    @Binding var age: String
    @Binding var gender: String
    let genders = ["남성", "여성"]
    
    var body: some View {
        VStack(alignment:.leading,spacing: 15){
            Text("""
                나이와 성별을
                     설정해주세요
                """)
            .font(.largeTitle)
            .bold()
            .padding()
            VStack(alignment:.leading){
                Text("나이")
                    .font(.headline)
                TextField("나이를 입력하세요", text: $age)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(.systemGray6)).shadow(radius: 10))
            }
            .padding()
            VStack(alignment:.leading){
                Text("성별")
                    .font(.headline)
                Picker("gender", selection: $gender) {
                    ForEach(genders, id:\.self) {
                        Text($0)
                    }
                }
                .frame(height: 45)
                .pickerStyle(.segmented)
                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(.systemGray6)).shadow(radius: 10))
            }
            .padding()
        }
        .padding()
    }
}

extension UISegmentedControl {
  override open func didMoveToSuperview() {
     super.didMoveToSuperview()
     self.setContentHuggingPriority(.defaultLow, for: .vertical)
   }
}

//#Preview {
//    AgeGenderSetupView()
//}
