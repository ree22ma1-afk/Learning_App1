import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var vm: LearningViewModel

    // للتنقل بين الشاشات
    @State private var showCalendar = false
    @State private var showGoalEditor = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                header
                weekStrip
                statsRow

                // إذا الهدف شغال: الأزرار. وإلا: شاشة النجاح أو الفشل
                if vm.goalState == .inProgress {
                    Spacer()
                    logButton
                    Spacer()
                    freezeButton
                } else {
                    GoalCompletionView(isCompleted: vm.goalState == .completed)
                }
            }
            .padding()
            .navigationDestination(isPresented: $showCalendar) {
                ActivitiesCalendarView()
            }
            .navigationDestination(isPresented: $showGoalEditor) {
                ChangeLearningGoalView()
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    // العنوان + الأيقونتين
    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Activity")
                    .font(.largeTitle)
                    .bold()
                Text(vm.headerDate)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            iconButton("calendar") { showCalendar = true }
            iconButton("pencil.and.outline") { showGoalEditor = true }
        }
    }

    private func iconButton(_ name: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: name)
                .foregroundStyle(.primary)
                .frame(width: 44, height: 44)
                .background(Color(.systemGray6))
                .clipShape(Circle())
        }
    }

    // أيام الأسبوع
    private var weekStrip: some View {
        let letters = ["S", "M", "T", "W", "T", "F", "S"]
        return HStack {
            ForEach(Array(vm.weekDays.enumerated()), id: \.offset) { index, date in
                VStack {
                    Text(letters[index])
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.secondary)
                    DayCircle(date: date, size: 40)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    // عداد الأيام المتعلمة والمجمدة
    private var statsRow: some View {
        HStack {
            statCard(icon: "flame.fill", color: .orange, value: vm.learnedCount, label: "Learned")
            statCard(icon: "snowflake", color: .iceBlue, value: vm.frozenCount, label: "Freezed")
        }
    }

    private func statCard(icon: String, color: Color, value: Int, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundStyle(color)
            Text("\(value) days")
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    // الزر الكبير: Log as Learned
    private var logButton: some View {
        let done = (vm.todayStatus == .learned)
        return Button {
            vm.logLearned()
        } label: {
            Text(done ? "Logged as Learned" : "Log as Learned")
                .font(.title3.bold())
                .foregroundStyle(done ? Color.secondary : Color.white)
                .frame(width: 270, height: 270)
                .background(done ? Color(.systemGray6) : Color.orange)
                .clipShape(Circle())
        }
        .frame(maxWidth: .infinity)
    }

    // زر التجميد
    private var freezeButton: some View {
        let disabledLook = (vm.todayStatus == .frozen) || vm.noFreezesLeft
        return VStack(spacing: 12) {
            Button {
                vm.freezeToday()
            } label: {
                Text(disabledLook ? "Freezed for a day" : "Freeze for a day")
                    .foregroundStyle(disabledLook ? Color.secondary : Color.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(disabledLook ? Color(.systemGray6) : Color.iceBlue)
                    .clipShape(Capsule())
            }

            Text("\(vm.frozenCount) out of \(vm.maxFreezes) Freezes used")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ActivityView()
        .environmentObject(LearningViewModel())
        .preferredColorScheme(.dark)
}
