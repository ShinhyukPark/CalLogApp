//
//  MyModel.swift
//  CalLog
//
//  Created by Shinhyuk Park on 8/3/24.
//

import Foundation
import SwiftData

//배열로 관리할 것은 SwiftData로, 단순하게 보여지는 정보들은 UserDefaults로 관리

class MyModel: ObservableObject{
    
    @Published var weight: Double {
        didSet {
            UserDefaults.standard.set(weight, forKey: "weight")
        }
    }
    
    @Published var height: Double {
        didSet {
            UserDefaults.standard.set(height, forKey: "height")
        }
    }
    
    @Published var age: Int {
        didSet {
            UserDefaults.standard.set(age, forKey: "age")
        }
    }
    @Published var calorie: Double {
        didSet {
            UserDefaults.standard.set(calorie, forKey: "calorie")
        }
    }
    
    @Published var gender: String {
        didSet {
            UserDefaults.standard.set(gender, forKey: "gender")
        }
    }
    
    @Published var activityLevel: Double {
        didSet {
            UserDefaults.standard.set(activityLevel, forKey: "activityLevel")
        }
    }
    
    @Published var activityName: String {
        didSet {
            UserDefaults.standard.set(activityName, forKey: "activityName")
        }
    }
    
    @Published var targetWeight: Double {
        didSet {
            UserDefaults.standard.set(targetWeight, forKey: "targetWeight")
        }
    }
    
    @Published var targetCalorie: Double {
        didSet {
            UserDefaults.standard.set(targetCalorie, forKey: "targetCalorie")
        }
    }
    
    init() {
        self.weight = UserDefaults.standard.double(forKey: "weight")
        self.height = UserDefaults.standard.double(forKey: "height")
        self.age = UserDefaults.standard.integer(forKey: "age")
        self.calorie = UserDefaults.standard.double(forKey: "calorie")
        self.gender = UserDefaults.standard.string(forKey: "gender") ?? "남성"
        self.activityLevel = UserDefaults.standard.double(forKey: "activityLevel")
        self.activityName = UserDefaults.standard.string(forKey: "activityName") ?? "매우 적은 활동량"
        self.targetWeight = UserDefaults.standard.double(forKey: "targetWeight")
        self.targetCalorie = UserDefaults.standard.double(forKey: "targetCalorie")
    }
}

@Model
class WeightEntry {
    let id = UUID()
    let date: Date
    var weight: Double
    
    init(date: Date = Date(), weight: Double = 0) {
        self.date = date
        self.weight = weight
    }
}

@Model
class CalorieData: ObservableObject {
    let id = UUID()
    let date: Date
    var calorie: Double
    
    init(date: Date = Date(), calorie: Double = 0) {
        self.date = date
        self.calorie = calorie
    }
}

@Model
class Food {
    let id = UUID()
    var food: String
    var calorie: Double
    
    init(food: String = "", calorie: Double = 0) {
        self.food = food
        self.calorie = calorie
    }
}
