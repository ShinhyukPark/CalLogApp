//
//  WeightView.swift
//  CalLog
//
//  Created by Shinhyuk Park on 8/3/24.
//
//
import SwiftUI
import Charts
import SwiftData

struct WeightView: View {
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM / dd"
        return formatter
    }
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var myModel: MyModel
    @Query(sort: \WeightEntry.date, order: .reverse) var weightArr: [WeightEntry]
    
    @State private var scrollPosition: String = ""
    @State private var showingAlert0 = false
    @State private var showingAlert1 = false
    @State private var target = ""
    @State private var current = ""
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack {
                    Text(String(format:"몸무게 : %.1f kg", myModel.weight))
                        .font(.system(size: 25,weight: .bold))
                        .padding()
                    Spacer()
                }
                Chart{
                    ForEach(weightArr.prefix(30).sorted(by: {$0.date < $1.date}), id: \.date) { item in
                        LineMark(x: .value("Date", formattedDate(date: item.date)),
                                 y: .value("Weight", item.weight))
                        PointMark(x: .value("Date",formattedDate(date: item.date)),
                                  y: .value("Weight", item.weight))
                        .annotation {
                            Text(String(format:"%.1f", item.weight))
                                .font(.system(size: 10, weight: .medium))
                        }
                        if myModel.targetWeight > 0 {
                            RuleMark(y:.value("Target", myModel.targetWeight)).foregroundStyle(Color.red).lineStyle(StrokeStyle(lineWidth: 2, dash:[5]))
                                .annotation(alignment:.trailing) {
                                    Text(String(format:"%.1f kg", myModel.targetWeight))
                                        .foregroundStyle(Color.gray)
                                        .font(.system(size: 15))
                                }
                        }
                    }
                }
                .chartYAxis{
                    AxisMarks(values: .stride(by: 10))
                    
                }
                .frame(height: 300)
                .chartScrollableAxes(.horizontal)
                .chartScrollPosition(x: $scrollPosition)
                if myModel.targetWeight > 0 {
                    if myModel.targetWeight == myModel.weight{
                        Text("축하합니다! 당신의 노력이 결실을 맺었어요! 🎉")
                            .font(.headline)
                    }else{
                        Text("목표까지 약 \(String(format:"%.1f",abs(myModel.weight - myModel.targetWeight))) kg 남았습니다")
                            .font(.body)
                            .foregroundStyle(Color.gray)
                    }
                }
                if weightArr.count == 1 {
                    Text("첫 기록은 그래프 표현이 부족 할 수 있습니다 !")
                        .font(.body)
                }
                ScrollView {
                    LazyVStack(spacing:10){
                        ForEach(Array(weightArr.enumerated()),id: \.element){ index, item in
                            HStack{
                                Text("\(dateFormatter.string(from: item.date))")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                                HStack{
                                    Text(String(format:"%.1f kg", item.weight))
                                        .padding(.trailing)
                                    if index < weightArr.count - 1 {
                                        let nextItem = weightArr[index + 1]
                                        if item.weight > nextItem.weight {
                                            Text((String(format:"↑ %.1f",item.weight - nextItem.weight)))
                                                .foregroundColor(.red)
                                        } else if item.weight < nextItem.weight {
                                            Text((String(format:"↓ %.1f",abs(item.weight - nextItem.weight))))
                                                .foregroundColor(.blue)
                                        }else{
                                            if item.weight == nextItem.weight {
                                                Text("- - - -")
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            Divider()
                        }
                        
                    }
                    .padding()
                }
            }
            .padding()
            .onAppear {
                if weightArr.count == 0 {
                    modelContext.insert(WeightEntry(date:Date(),weight: myModel.weight))
                }
                
                //EditView에서 수정해도 반영되게 설정
                if weightArr.first?.weight != myModel.weight {
                    weightArr.first?.weight = myModel.weight
                }
                
                //그래프 위치를 우측으로 고정하기 위해
                if let firstPosition = weightArr.first?.date {
                    scrollPosition = formattedDate(date: firstPosition)
                }else{
                    scrollPosition = formattedDate(date: Date())
                }
            }
            .alert("목표 몸무게",isPresented:$showingAlert0){
                TextField("입력",text: $target)
                    .keyboardType(.decimalPad)
                Button("확인"){
                    myModel.targetWeight = Double(target) ?? 0
                }
                Button("취소",role: .cancel) {}
            }
            .alert("오늘 몸무게",isPresented:$showingAlert1){
                TextField("입력",text: $current)
                    .keyboardType(.decimalPad)
                Button("확인"){
                    myModel.weight = Double(current) ?? 0
                    if let index = weightArr.firstIndex(where: {Calendar.current.isDate($0.date, inSameDayAs: Date())}) {
                        weightArr[index].weight = myModel.weight
                    }else{
                        modelContext.insert(WeightEntry(date: Date(), weight: myModel.weight))
                    }
                }
                Button("취소",role: .cancel) {}
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
                        showingAlert1.toggle()
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
        return WeightView()
            .environmentObject(MyModel())
            .modelContainer(container)
    } catch {
        fatalError()
    }
}
