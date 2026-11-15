import SwiftUI

struct GoalCompletionView: View {
    @EnvironmentObject var vm: LearningViewModel
    let isCompleted: Bool   // true = Well done / false = ما حقق الهدف

    var body: some View {
        VStack(spacing: 12) {
            Spacer()

            Image(systemName: isCompleted ? "hands.clap.fill" : "xmark.seal")
                .font(.system(size: 48))
                .foregroundStyle(.orange)

            Text(isCompleted ? "Well done!" : "You didn't reach your goal this time.")
                .font(.headline)
                .multilineTextAlignment(.center)

            Text(isCompleted ? "Ready for your next goal?" : "Want to set another goal?")
                .foregroundStyle(.secondary)

            Button {
                vm.resetGoal()   // يرجعك لشاشة Onboarding
            } label: {
                Label("Set a goal", systemImage: "pencil.and.outline")
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(Color.orange)
                    .clipShape(Capsule())
            }
            .padding(.top, 40)

            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview("Well done") {
    GoalCompletionView(isCompleted: true)
        .environmentObject(LearningViewModel())
        .preferredColorScheme(.dark)
}

#Preview("Goal not met") {
    GoalCompletionView(isCompleted: false)
        .environmentObject(LearningViewModel())
        .preferredColorScheme(.dark)
}
