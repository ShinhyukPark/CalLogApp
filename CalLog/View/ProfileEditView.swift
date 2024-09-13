//
//  MeView.swift
//  CalLog
//
//  Created by Shinhyuk Park on 8/3/24.
//

import SwiftUI

struct ProfileEditView: View {
    
    @EnvironmentObject var myModel: MyModel
    
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var age: String = ""
    @State private var gender: String = "남성"
    @State private var activityLevel: Double = 1.2
    @State private var activityName: String = "매우 적은 활동량"
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing:10){
            VStack(alignment:.leading){
                Text("키").font(.headline)
                TextField("입력", text: $height)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
            VStack(alignment:.leading){
                Text("몸무게").font(.headline)
                TextField("입력", text: $weight)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
            VStack(alignment:.leading){
                Text("나이").font(.headline)
                TextField("입력", text: $age)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
            HStack{
                Text("성별").font(.headline)
                Spacer()
                Menu{
                    Button("여성"){
                        gender = "여성"
                    }
                    Button("남성"){
                        gender = "남성"
                    }
                }label: {
                    Text(gender)
                }
            }
            .padding()
            HStack{
                Text("활동수준").font(.headline)
                Spacer()
                Menu {
                    Button("매우 많은 활동량"){
                        activityName = "매우 많은 활동량"
                        activityLevel = 1.9
                    }
                    Button("많은 활동량"){
                        activityName = "많은 활동량"
                        activityLevel = 1.725
                    }
                    Button("보통 활동량"){
                        activityName = "보통 활동량"
                        activityLevel = 1.55
                    }
                    Button("가벼운 활동량"){
                        activityName = "가벼운 활동량"
                        activityLevel = 1.375
                    }
                    Button("매우 적은 활동량"){
                        activityName = "매우 적은 활동량"
                        activityLevel = 1.2
                    }
                }label: {
                    Text(activityName)
                    
                }
            }
            .padding()
            Button{
                myModel.weight = Double(weight) ?? 0
                myModel.height = Double(height) ?? 0
                myModel.age = Int(age) ?? 0
                myModel.gender = gender
                myModel.activityLevel = activityLevel
                myModel.activityName = activityName
                dismiss()
            }label: {
                Text("저장")
                    .font(.headline)
            }
            .disabled(!isChecked())
            .padding()
        }
        //다시 EditView를 나타낼때 입력창에 입력한 값을 설정
        .onAppear{
            if myModel.height > 0 {
                height = String(myModel.height)
                weight = String(myModel.weight)
                age = String(myModel.age)
                gender = myModel.gender
                activityName = myModel.activityName
            }
        }
    }
    //버튼을 disabled하기 위한 조건
    func isChecked() -> Bool{
        return Double(weight) != nil && Double(height) != nil && Double(age) != nil
    }
}


#Preview {
    ProfileView().environmentObject(MyModel())
}
