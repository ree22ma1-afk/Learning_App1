import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var vm: LearningViewModel

    // اللي يكتبه المستخدم (ما يتحفظ إلا لما يضغط Start Learning)
    @State private var subject = ""
    @State private var duration: LearningDuration = .week

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // الشعار
            Image(systemName: "flame.fill")
                .font(.system(size: 44))
                .foregroundStyle(.orange)
                .frame(maxWidth: .infinity)
                .padding(.top, 40)

            // العنوان
            Text("Hello **Learner**")
                .font(.largeTitle)
                .padding(.top, 40)

            Text("This app will help you learn everyday!")
                .foregroundStyle(.secondary)

            // الموضوع
            Text("I want to learn")
                .padding(.top, 24)

            TextField("Swift", text: $subject)

            Divider()

            // المدة
            Text("I want to learn it in a")
                .padding(.top, 16)

            DurationPicker(selected: $duration)

            Spacer()

            // زر البداية
            Button {
                vm.saveGoal(subject: subject, duration: duration)
            } label: {
                Text("Start Learning")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 14)
                    .background(Color.orange)
                    .clipShape(Capsule())
            }
            .disabled(subject.isEmpty)               // ما يشتغل إذا الحقل فاضي
            .opacity(subject.isEmpty ? 0.5 : 1)
            .frame(maxWidth: .infinity)

            Text("You can edit your desire later")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
        }
        .padding()
    }
}

#Preview {
    OnboardingView()
        .environmentObject(LearningViewModel())
        .preferredColorScheme(.dark)
}
