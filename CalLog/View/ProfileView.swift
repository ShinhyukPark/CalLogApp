//
//  ProfileView.swift
//  CalLog
//
//  Created by Shinhyuk Park on 8/3/24.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var myModel: MyModel
    
    var body: some View {
        VStack(alignment:.leading, spacing: 15){
            VStack(alignment:.leading){
                Text("키").font(.headline)
                Text(String(format:"%.1fcm", myModel.height)).font(.body)
            }
            .padding()
            VStack(alignment:.leading){
                Text("몸무게").font(.headline)
                Text(String(format:"%.1fkg", myModel.weight)).font(.body)
            }
            .padding()
            VStack(alignment:.leading){
                Text("나이").font(.headline)
                Text("\(myModel.age)세").font(.body)
            }
            .padding()
            HStack{
                Text("성별").font(.headline)
                Spacer()
                Text(myModel.gender).font(.body)
            }
            .padding()
            HStack{
                Text("활동수준").font(.headline)
                Spacer()
                Text(myModel.activityName).font(.body)
            }
            .padding()
            HStack{
                Text("나의 예상 기초대사량").font(.headline)
                Spacer()
                if myModel.gender == "남성" {
                    let bmr = manBmr(weight: myModel.weight, height: myModel.height, age: Double(myModel.age)) * myModel.activityLevel
                    Text("\(Int(bmr))Kcal").font(.body)
                }else if myModel.gender == "여성" {
                    let bmr = womanBmr(weight: myModel.weight, height: myModel.height, age: Double(myModel.age)) * myModel.activityLevel
                    Text("\(Int(bmr))Kcal").font(.body)
                }else{
                    let bmr = (manBmr(weight: myModel.weight, height: myModel.height, age: Double(myModel.age)) + womanBmr(weight: myModel.weight, height: myModel.height, age: Double(myModel.age))) / 2  * myModel.activityLevel
                    Text("\(Int(bmr))Kcal").font(.body)
                }
            }
            .padding()
        }
        .padding()
    }
    
    //BMR 계산 함수
    func manBmr(weight: Double, height: Double, age: Double) -> Double {
        var bmr: Double = 0
        bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5
        return bmr
    }

    func womanBmr(weight: Double, height: Double, age: Double) -> Double {
        var bmr: Double = 0
        bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161
        return bmr
    }

}


#Preview {
    ProfileView().environmentObject(MyModel())
}
