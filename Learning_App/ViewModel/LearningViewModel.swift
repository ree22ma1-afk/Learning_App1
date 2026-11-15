import SwiftUI
import Combine

class LearningViewModel: ObservableObject {

    // للتجربة: true = يمسح البيانات كل ما تشغّل التطبيق، فيطلع Onboarding دايماً
    // قبل التسليم خله false عشان الهدف يبقى محفوظ
    static let resetOnLaunch = true

    // تقويم ميلادي (عشان جهازك ما يستخدم الهجري)
    let calendar = Calendar(identifier: .gregorian)

    // MARK: - البيانات (أي تغيير فيها يتحفظ تلقائياً)

    @Published var subject: String {
        didSet { UserDefaults.standard.set(subject, forKey: "subject") }
    }

    @Published var duration: LearningDuration {
        didSet { UserDefaults.standard.set(duration.rawValue, forKey: "duration") }
    }

    @Published var hasOnboarded: Bool {
        didSet { UserDefaults.standard.set(hasOnboarded, forKey: "hasOnboarded") }
    }

    @Published var goalStart: Date {
        didSet { UserDefaults.standard.set(goalStart, forKey: "goalStart") }
    }

    // سجل الأيام، مثال: ["2026-06-01": "learned"]
    @Published var logs: [String: String] {
        didSet { UserDefaults.standard.set(logs, forKey: "logs") }
    }

    // MARK: - يقرأ البيانات المحفوظة أول ما يفتح التطبيق

    init() {
        // يمسح البيانات القديمة إذا المفتاح فوق true
        if LearningViewModel.resetOnLaunch {
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier ?? "")
        }

        let d = UserDefaults.standard
        subject = d.string(forKey: "subject") ?? ""
        duration = LearningDuration(rawValue: d.string(forKey: "duration") ?? "") ?? .week
        hasOnboarded = d.bool(forKey: "hasOnboarded")
        goalStart = d.object(forKey: "goalStart") as? Date ?? Date()
        logs = d.dictionary(forKey: "logs") as? [String: String] ?? [:]
    }

    // MARK: - الحسابات

    // يحول التاريخ لنص (نستخدمه كمفتاح في السجل)
    func dayKey(_ date: Date) -> String {
        let f = DateFormatter()
        f.calendar = calendar
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }

    // حالة يوم معين: learned أو frozen أو nil (ما سجّل)
    func status(for date: Date) -> DayStatus? {
        DayStatus(rawValue: logs[dayKey(date)] ?? "")
    }

    var todayStatus: DayStatus? { status(for: Date()) }

    var learnedCount: Int { logs.values.filter { $0 == "learned" }.count }
    var frozenCount: Int { logs.values.filter { $0 == "frozen" }.count }

    var maxFreezes: Int { duration.maxFreezes }
    var noFreezesLeft: Bool { frozenCount >= maxFreezes }

    // حالة الهدف: شغال / نجح / ما حققه
    var goalState: GoalState {
        if learnedCount >= duration.targetDays { return .completed }

        let startDay = calendar.startOfDay(for: goalStart)
        let endDay = calendar.date(byAdding: .day, value: duration.targetDays, to: startDay) ?? .distantFuture
        if Date() >= endDay { return .notMet }

        return .inProgress
    }

    // النص تحت كلمة Activity، مثال: Thursday, 24 October
    var headerDate: String {
        let f = DateFormatter()
        f.calendar = calendar
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "EEEE, d MMMM"
        return f.string(from: Date())
    }

    // أيام الأسبوع الحالي (من الأحد)
    var weekDays: [Date] {
        guard let start = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: start) }
    }

    // أشهر التقويم: سنة كاملة (12 شهر) من شهر بداية الهدف
    var months: [Date] {
        guard let first = calendar.dateInterval(of: .month, for: goalStart)?.start else { return [] }
        return (0..<12).compactMap { calendar.date(byAdding: .month, value: $0, to: first) }
    }

    // MARK: - الإجراءات (اللي يسوونها الأزرار)

    func logLearned() {
        guard todayStatus == nil else { return }   // ما نسمح بتسجيلين في نفس اليوم
        logs[dayKey(Date())] = "learned"
    }

    func freezeToday() {
        guard todayStatus == nil, !noFreezesLeft else { return }
        logs[dayKey(Date())] = "frozen"
    }

    // يحفظ هدف جديد (من Onboarding أو من شاشة تعديل الهدف) ويصفّر الـ streak
    func saveGoal(subject: String, duration: LearningDuration) {
        self.subject = subject.trimmingCharacters(in: .whitespacesAndNewlines)
        self.duration = duration
        goalStart = Date()
        logs = [:]
        hasOnboarded = true
    }

    // زر Set a goal: يرجعك لشاشة Onboarding
    func resetGoal() {
        logs = [:]
        hasOnboarded = false
    }
}
