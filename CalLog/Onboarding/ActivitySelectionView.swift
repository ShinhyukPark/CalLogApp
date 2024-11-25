//
//  ActivitySelectionView.swift
//  CalLog
//
//  Created by Shinhyuk Park on 9/1/24.
//

import SwiftUI

struct ActivitySelectionView: View {
    @State private var selectedActivityName: String = ""
    
    let activityNames = ["매우 적은 활동량 (주로 앉는 시간이 많음)", "가벼운 활동량 (주 1~2회 운동)", "보통 활동량 (주 3~5회 운동)", "많은 활동량 (주 6~7회 운동)", "매우 많은 활동량 (매일 2회 이상의 운동)"]
    let activityLevels = [1.2, 1.375, 1.55, 1.725, 1.9]
    
    @Binding var activityName: String
    @Binding var activityLevel: Double
    
    var body: some View {
        VStack(spacing: 10) {
            Text("활동 수준을 골라주세요")
                .font(.largeTitle)
                .bold()
                .padding()
            ForEach(activityNames, id: \.self) { level in
                Button(action: {
                    selectedActivityName = level
                    activityName = saveActivity()
                     if let index = activityNames.firstIndex(of: level) {
                        activityLevel = activityLevels[index]
                    }
                }) {
                    Text(level)
                        .padding()
                        .frame(maxWidth:.infinity)
                        .background(selectedActivityName == level ? Color.blue : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10)).shadow(radius: 10)
                        .foregroundStyle(selectedActivityName == level ? .white : .black)
                }
                .padding(.top)
            }
        }
        .padding()
    }
    
    func saveActivity() -> String{
        switch selectedActivityName {
        case "매우 적은 활동량 (주로 앉는 시간이 많음)":
            return "매우 적은 활동량"
        case "가벼운 활동량 (주 1~2회 운동)":
            return "가벼운 활동량"
        case "보통 활동량 (주 3~5회 운동)":
            return "보통 활동량"
        case "많은 활동량 (주 6~7회 운동)":
            return "많은 활동량"
        default:
            return "매우 많은 활동량"
        }
    }
}

//#Preview {
//    ActivitySelectionView()
//}
