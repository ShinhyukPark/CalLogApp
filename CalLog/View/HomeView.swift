//
//  HomeView.swift
//  CalLog
//
//  Created by Shinhyuk Park on 8/3/24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var myModel: MyModel
    
    @State private var showBmiAlert = false
    @State private var showTipsAlert = false
    
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
        case 30..<34.9:
            return "비만 1단계"
        case 35..<39.9:
            return "비만 2단계"
        default:
            return "비만 3단계"
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
                건강한 식단 유지하기
                
                다양한 식품, 특히 과일, 채소, 콩류, 견과류, 통곡물을 섭취하세요.
                
                하루에 최소 5회(400g)의 과일과 채소를 섭취하는 것이 좋습니다.
                
                이는 영양실조와 당뇨, 심장병 등의 비전염성 질병(NCD) 위험을 줄입니다.
                """,
                """
                소금과 설탕 섭취 줄이기
                
                하루에 소금 섭취량을 5g 이하로 제한하고, 설탕 섭취량도 총 에너지 섭취의 5% 미만으로 줄이세요.
                
                지나친 설탕 섭취는 충치와 비만을 유발할 수 있습니다.
                """,
                """
                해로운 지방 섭취 줄이기
                
                지방 섭취는 총 에너지의 30% 이하로 제한하고, 포화지방과 트랜스지방 대신 불포화지방을 섭취하세요.
                
                불포화지방은 생선, 견과류, 식물성 기름에 풍부합니다.
                """,
                """
                알코올 섭취 피하기
                
                알코올 섭취에는 안전한 수준이 없습니다.
                
                알코올은 정신적, 신체적 질병을 유발할 수 있으며, 특히 간경변과 심장 질환을 촉발합니다.
                """,
                """
                담배를 피우지 마세요.
                                                    
                담배는 폐질환, 심장병, 뇌졸중 등의 질병을 유발하며, 간접흡연도 건강에 해롭습니다.
                
                금연은 즉각적이고 장기적인 건강 혜택을 줍니다.
                """,
                """
                활동적으로 생활하기
                
                성인은 매주 최소 150분의 중간 강도 신체 활동을 하세요.
                
                더 많은 활동은 추가적인 건강 혜택을 줍니다.
                """,
                """
                혈압 정기적으로 체크하기
                
                고혈압은 “조용한 살인자”로 불리며, 증상이 없을 수 있습니다.
                
                정기적으로 혈압을 체크하고, 고혈압이 있다면 건강 전문가의 도움을 받는 것이 중요합니다.
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
                Text("\(String(format: "%.1f",myModel.weight)) Kg")
                    .font(.title)
                    .foregroundStyle(.primary)
            }
            .padding()
            VStack(alignment: .leading, spacing: 5){
                HStack {
                    Text("BMI")
                        .font(.headline)
                    Button {
                        showBmiAlert.toggle()
                    } label: {
                        Image(systemName: "questionmark.circle")
                            .foregroundStyle(Color.blue)
                            .font(.headline)
                    }
                    .confirmationDialog("BMI 출처", isPresented: $showBmiAlert) {
                        Button {
                            if let url = URL(string: "https://www.who.int/europe/news-room/fact-sheets/item/a-healthy-lifestyle---who-recommendations"){
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Text("BMI 계산 출처 WHO(2010)")
                        }
                    }
                }
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
                HStack {
                    Text("오늘의 건강팁")
                        .font(.headline)
                    .padding(.bottom, 5)
                    Button {
                        showTipsAlert.toggle()
                    } label: {
                        Image(systemName: "questionmark.circle")
                            .foregroundStyle(Color.blue)
                            .font(.headline)
                            .padding(.bottom, 5)
                    }
                    .confirmationDialog("건강팁 출처", isPresented: $showTipsAlert) {
                        Button {
                            if let url = URL(string: "https://www.who.int/philippines/news/feature-stories/detail/20-health-tips-for-2020"){
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Text("건강팁 출처 WHO(2020)")
                        }
                    }
                }
                ScrollView {
                    Text(dailyTip)
                        .font(.body)
                        .padding()
                }
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
