import SwiftUI

// لون التجميد (الأزرق)
extension Color {
    static let iceBlue = Color(red: 0.40, green: 0.80, blue: 0.95)
}

// ============================================
// أجزاء مشتركة (نستخدمها في أكثر من شاشة)
// ============================================

// اختيار المدة: Week / Month / Year
struct DurationPicker: View {
    @Binding var selected: LearningDuration

    var body: some View {
        HStack {
            ForEach(LearningDuration.allCases) { item in
                Button {
                    selected = item
                } label: {
                    Text(item.rawValue)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .foregroundStyle(selected == item ? Color.white : Color.secondary)
                        .background(selected == item ? Color.orange : Color(.systemGray6))
                        .clipShape(Capsule())
                }
            }
        }
    }
}

// دايرة اليوم: برتقالي (تعلمت) / أزرق (جمدت) / برتقالي كامل (اليوم)
struct DayCircle: View {
    @EnvironmentObject var vm: LearningViewModel
    let date: Date
    let size: CGFloat

    var status: DayStatus? { vm.status(for: date) }

    var textColor: Color {
        if status == .learned { return .orange }
        if status == .frozen { return .iceBlue }
        if vm.calendar.isDateInToday(date) { return .white }
        return .primary
    }

    var backgroundColor: Color {
        if status == .learned { return Color.orange.opacity(0.2) }
        if status == .frozen { return Color.iceBlue.opacity(0.2) }
        if vm.calendar.isDateInToday(date) { return .orange }
        return .clear
    }

    var body: some View {
        Text("\(vm.calendar.component(.day, from: date))")
            .foregroundStyle(textColor)
            .frame(width: size, height: size)
            .background(backgroundColor)
            .clipShape(Circle())
    }
}
