import Foundation

// مدة الهدف
enum LearningDuration: String, CaseIterable, Identifiable {
    case week = "Week"
    case month = "Month"
    case year = "Year"

    var id: String { rawValue }

    // عدد الأيام المطلوبة لإكمال الهدف
    var targetDays: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        case .year: return 365
        }
    }

    // عدد التجميدات المسموحة
    var maxFreezes: Int {
        switch self {
        case .week: return 2
        case .month: return 8
        case .year: return 96
        }
    }
}

// حالة اليوم
enum DayStatus: String {
    case learned
    case frozen
}

// حالة الهدف
enum GoalState {
    case inProgress
    case completed
    case notMet
}
