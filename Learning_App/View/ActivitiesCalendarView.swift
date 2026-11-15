import SwiftUI

struct ActivitiesCalendarView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm: LearningViewModel

    let weekdays = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        VStack {
            // الشريط العلوي
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.primary)
                        .frame(width: 44, height: 44)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }

                Spacer()
                Text("Activities")
                    .font(.headline)
                Spacer()
                Color.clear.frame(width: 44, height: 44)   // عشان العنوان يكون بالنص
            }
            .padding(.horizontal)

            // الأشهر
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(vm.months, id: \.self) { month in
                        if month != vm.months.first {
                            Divider()
                        }
                        monthView(month)
                    }
                }
                .padding()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    // شهر واحد: العنوان + أيام الأسبوع + الأيام
    func monthView(_ monthStart: Date) -> some View {
        let cal = vm.calendar
        let emptyCells = cal.component(.weekday, from: monthStart) - 1   // خانات فاضية قبل أول يوم
        let daysCount = cal.range(of: .day, in: .month, for: monthStart)?.count ?? 30

        let formatter = DateFormatter()
        formatter.calendar = cal
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "LLLL yyyy"

        return VStack(alignment: .leading, spacing: 12) {
            Text(formatter.string(from: monthStart))
                .font(.headline)

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(weekdays, id: \.self) { name in
                    Text(name)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                ForEach(0..<emptyCells, id: \.self) { _ in
                    Color.clear.frame(height: 36)
                }

                ForEach(1...daysCount, id: \.self) { day in
                    if let date = cal.date(byAdding: .day, value: day - 1, to: monthStart) {
                        DayCircle(date: date, size: 36)
                    }
                }
            }
        }
    }
}

// معاينة فيها شهرين قبل اليوم عشان تشوف أكثر من شهر
#Preview {
    let vm = LearningViewModel()
    vm.goalStart = Calendar(identifier: .gregorian).date(byAdding: .month, value: -2, to: Date()) ?? Date()

    return NavigationStack {
        ActivitiesCalendarView()
    }
    .environmentObject(vm)
    .preferredColorScheme(.dark)
}
