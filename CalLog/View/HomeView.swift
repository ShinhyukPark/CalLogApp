//
//  HomeView.swift
//  CalLog
//
//  Created by Shinhyuk Park on 8/3/24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var myModel: MyModel
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 (E)"
        return formatter
    }
    
    var bmi: Double{
        myModel.weight / (myModel.height * myModel.height / 10000)
    }
    
    private var bmiCategory: String {
        switch bmi {
        case ..<18.5:
            return "저체중"
        case 18.5..<24.9:
            return "정상 체중"
        case 25..<29.9:
            return "과체중"
        default:
            return "비만"
        }
    }
    private var categoryColor: Color {
        switch bmi {
        case ..<18.5:
            return .blue
        case 18.5..<24.9:
            return .green
        case 25..<29.9:
            return .orange
        default:
            return .red
        }
    }
    
    private let tips = [
                """
                하루 2 ~ 3잔의 커피를 마셔보세요.
                
                심혈관 질환 예방에 도움이 되고,
                체내 염증을 줄여줍니다.
                """,
                """
                매일 15분씩 운동해보세요.
                
                규칙적인 운동은 신진대사를 촉진하고,
                체력 향상과 건강에 큰 도움이 됩니다.
                """,
                """
                새로운 것을 배워보세요.
                
                뇌를 자극하는 활동은 정신 건강과
                스트레스 관리에 도움이 됩니다.
                """,
                """
                외출 후에는 20초 이상 손을 씻어보세요.
                
                호흡기 감염을 포함한 다양한 질병 예방에 효과적입니다.
                """,
                """
                의식적으로 충분한 물을 마셔보세요.
                                                    
                신진대사와 체내 노폐물 배출을 돕습니다.
                """,
                """
                충분한 수면을 취해보세요.
                
                수면은 피로 회복과 면역력 강화에 필수입니다.
                """,
                """
                긍정적인 마인드를 유지해보세요.
                
                긍정적인 사고는 스트레스를 완화하고,
                면역 체계를 강화합니다.
                """
                
    ]
    
    private var dailyTip: String {
        let index = Calendar.current.component(.day, from: Date()) % tips.count
        return tips[index]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("안녕하세요!")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.primary)
            Text("오늘은 \(dateFormatter.string(from: Date()))")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 5){
                Text("현재 몸무게")
                    .font(.headline)
                Text("\(String(format: "%.1f",myModel.weight))Kg")
                    .font(.title)
                    .foregroundStyle(.primary)
            }
            .padding()
            VStack(alignment: .leading, spacing: 5){
                Text("BMI")
                    .font(.headline)
                Text("\(String(format: "%.1f", bmi))")
                    .font(.title)
                Text(bmiCategory)
                    .foregroundStyle(categoryColor)
                    .font(.subheadline)
            }
            .padding()
            VStack(alignment: .leading){
                Text("오늘 칼로리 현황")
                    .font(.headline)
                if myModel.targetCalorie > 0 {
                    Text("\(Int(myModel.calorie))/\(Int(myModel.targetCalorie))")
                        .font(.title)
                        .foregroundStyle(myModel.calorie > myModel.targetCalorie ? .red : .primary)
                }else{
                    Text("\(Int(myModel.calorie))")
                        .font(.title)
                        .foregroundStyle(.primary)
                }
            }
            .padding()
            Divider()
                .padding()
            VStack(alignment: .leading, spacing: 10){
                Text("오늘의 건강팁")
                    .font(.headline)
                    .padding(.bottom, 5)
                Text(dailyTip)
                    .font(.body)
                    .padding()
                    .foregroundColor(.primary)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 2)
            }
            .padding()
        }
        .padding()
    }
}


#Preview {
    HomeView().environmentObject(MyModel())
}
