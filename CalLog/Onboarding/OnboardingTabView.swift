//
//  OnboardingTabView.swift
//  CalLog
//
//  Created by Shinhyuk Park on 8/21/24.
//

import SwiftUI

struct OnboardingTabView: View {
    
    @EnvironmentObject var myModel: MyModel
    
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var age: String = ""
    @State private var gender: String = "남성"
    @State private var activityLevel: Double = 1.2
    @State private var activityName: String = "매우 적은 활동량"
    
    @State private var selectedPage = 0
    
    @Binding var onboarding: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()
                VStack{
                    if selectedPage == 0 {
                        WelcomeView()
                    }else if selectedPage == 1 {
                        PhysicalInputView(height: $height, weight: $weight)
                    }else if selectedPage == 2 {
                        AgeGenderSetupView(age: $age, gender: $gender)
                    }else if selectedPage == 3 {
                        ActivitySelectionView(activityName: $activityName, activityLevel: $activityLevel)
                    }
                    Spacer()
                    if selectedPage == 0 {
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedPage += 1
                            }
                        } label: {
                            Text("다음")
                                .font(.headline)
                                .foregroundStyle(Color.white)
                                .padding()
                                .frame(maxWidth:.infinity)
                                .background(RoundedRectangle(cornerRadius: 10).shadow(radius: 5))
                                .padding(.horizontal)
                        }
                        .padding(.bottom, 60)
                    }else{
                        Button {
                            if selectedPage == 3 {
                                myModel.activityLevel = activityLevel
                                myModel.activityName = activityName
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    onboarding = false
                                }
                            }else{
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedPage += 1
                                }
                                myModel.weight = Double(weight) ?? 0
                                myModel.height = Double(height) ?? 0
                                myModel.age = Int(age) ?? 0
                                myModel.gender = gender
                            }
                        } label: {
                            Text(selectedPage == 3 ? "확인" : "다음")
                                .font(.headline)
                                .foregroundStyle(Color.white)
                                .padding()
                                .frame(maxWidth:.infinity)
                                .background(RoundedRectangle(cornerRadius: 10).shadow(radius: 5))
                                .padding(.horizontal)
                        }
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                onboarding = false
                            }
                        }, label: {
                            Text("나중에 설정할게요")
                                .font(.body)
                                .foregroundStyle(Color.secondary)
                                .padding()
                        })
                        .toolbar{
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        selectedPage -= 1
                                    }
                                } label: {
                                    Image(systemName: "arrow.uturn.backward")
                                        .foregroundStyle(Color.black)
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
}

struct GradientBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.3529, green: 0.5529, blue: 0.6392),
                Color(red: 0.3765, green: 0.4941, blue: 0.4039)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea(edges: .all)
    }
}

//#Preview {
//    OnboardingTabView()
//}
