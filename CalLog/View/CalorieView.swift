//
//  CalorieView.swift
//  CalLog
//
//  Created by Shinhyuk Park on 8/3/24.
//

import SwiftUI
import Charts
import SwiftData

struct CalorieView: View {
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM / dd"
        return formatter
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var myModel: MyModel
    @Query private var caloriArr:[CalorieData]
    @Query private var food:[Food]
    
    @State private var foodName = ""
    @State private var calorieCount = ""
    @State private var showingAlert0 = false
    @State private var showingAlert1 = false
    @State private var target = ""
    @State private var averageCalories: Int = 1
    private var dayCount: Int {
        return max(1, min(7, caloriArr.count))
    }
    
    var body: some View {
        NavigationStack{
            VStack(alignment:.leading){
                let recentCalories = caloriArr.suffix(7).map{$0.calorie}
                let totalCalories = recentCalories.reduce(0, +)
                let averageCalories = Int(totalCalories) / dayCount
                Text("칼로리 : \(Int(myModel.calorie)) Kcal")
                    .font(.system(size: 25,weight: .bold))
                    .padding()
                caloriArr.count == 0 ? Text("   + 버튼으로 음식을 추가해주세요.")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.gray) :
                Text("최근 칼로리 평균: \(Int(averageCalories)) Kcal")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.gray)
                Chart{
                    ForEach(caloriArr.suffix(7), id: \.date){ item in
                        BarMark(x: .value("Date",formattedDate(date: item.date)), y:.value("Calorie", item.calorie))
                            .annotation {
                                Text("\(Int(item.calorie))")
                                    .font(.system(size: 12, weight: .medium))
                            }
                        if myModel.targetCalorie > 0 {
                            RuleMark(y: .value("Target", myModel.targetCalorie)).foregroundStyle(Color.red).lineStyle(StrokeStyle(lineWidth: 2, dash:[5]))
                        }
                        
                    }
                }
                .frame(height:150)
                if myModel.targetCalorie > 0 {
                    HStack{
                        if Int(myModel.targetCalorie - myModel.calorie) < 0 {
                            Text("오늘 목표 칼로리를 초과했어요! +\(abs(Int(myModel.targetCalorie - myModel.calorie))) Kcal")
                                .font(.system(size: 15))
                                .foregroundStyle(Color.gray)
                        }else{
                            Text("오늘 목표 칼로리까지 : \(Int(myModel.targetCalorie - myModel.calorie)) Kcal")
                                .font(.system(size: 15))
                                .foregroundStyle(Color.gray)
                        }
                    }
                }
                if showingAlert1{
                    VStack(alignment: .leading, spacing: 15) {
                        Text("음식 입력")
                            .padding(.leading)
                            .font(.headline)
                            .padding(.top)
                        VStack{
                            TextField("음식", text: $foodName)
                            Divider()
                            TextField("칼로리", text: $calorieCount)
                                .keyboardType(.decimalPad)
                            HStack {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showingAlert1 = false
                                    }
                                }) {
                                    Text("취소")
                                }
                                .padding(.trailing)
                                Button {
                                    modelContext.insert(Food(food: foodName, calorie: Double(calorieCount) ?? 0))
                                    if let index = caloriArr.firstIndex(where: {Calendar.current.isDate($0.date, inSameDayAs: Date())}){
                                        caloriArr[index].calorie += Double(calorieCount) ?? 0
                                        myModel.calorie += Double(calorieCount) ?? 0
                                    }else{
                                        myModel.calorie += Double(calorieCount) ?? 0
                                        modelContext.insert(CalorieData(date: Date(), calorie: Double(calorieCount) ?? 0))
                                    }
                                    foodName = ""
                                    calorieCount = ""
                                } label: {
                                    Text("추가")
                                        .padding(.trailing)
                                }
                                .disabled(Double(calorieCount) == nil)
                                .padding(.leading)
                            }
                            .frame(maxWidth:.infinity,alignment: .trailing)
                        }
                        .padding()
                    }
                    .background(RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(colorScheme == .dark ? Color(.systemGray4) : Color.white))
                    .shadow(radius: 7)
                }
                List{
                    ForEach(food){ item in
                        HStack{
                            Text(item.food)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer(minLength: 30)
                            Text("\(Int(item.calorie)) Kcal")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.vertical,8)
                    }
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            let removedFood = food[index]
                            modelContext.delete(removedFood)
                            
                            myModel.calorie -= removedFood.calorie
                            
                            if let index = caloriArr.firstIndex(where: {Calendar.current.isDate($0.date, inSameDayAs: Date())}) {
                                caloriArr[index].calorie -= removedFood.calorie
                            }
                        }
                    })
                }
                .scrollContentBackground(.hidden)
            }
            .onAppear {
                //날짜가 바뀔 경우 Food 배열을 초기화
                let today = Calendar.current.startOfDay(for: Date())
                
                if let lastDate = caloriArr.last?.date {
                    let lastDay = Calendar.current.startOfDay(for: lastDate )
                    
                    if !Calendar.current.isDate(lastDay, inSameDayAs: today) {
                        for i in food {
                            modelContext.delete(i)
                        }
                        myModel.calorie = 0
                    }
                }
            }
            .padding()
            .alert("목표 칼로리",isPresented: $showingAlert0){
                TextField("입력", text:$target)
                    .keyboardType(.decimalPad)
                Button("확인"){
                    myModel.targetCalorie = Double(target) ?? 0
                }
                Button("취소",role: .cancel){}
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingAlert0.toggle()
                    } label: {
                        Image(systemName: "target")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showingAlert1.toggle()
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    func formattedDate(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd"
            return formatter.string(from: date)
        }
}


#Preview {
    do{
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for:WeightEntry.self, CalorieData.self, Food.self, configurations: config)
        return CalorieView()
            .environmentObject(MyModel())
            .modelContainer(container)
    } catch {
        fatalError()
    }
}
