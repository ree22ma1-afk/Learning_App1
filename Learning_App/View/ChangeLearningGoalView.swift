import SwiftUI

struct ChangeLearningGoalView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm: LearningViewModel

    @State private var subject = ""
    @State private var duration: LearningDuration = .week
    @State private var showAlert = false

    // زر ✓ يشتغل بس إذا غيرت شي
    var hasChanges: Bool {
        !subject.isEmpty && (subject != vm.subject || duration != vm.duration)
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {

                // الشريط العلوي: رجوع - العنوان - تأكيد
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
                    Text("Learning Goal")
                        .font(.headline)
                    Spacer()

                    Button {
                        showAlert = true
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.orange)
                            .clipShape(Circle())
                    }
                    .disabled(!hasChanges)
                    .opacity(hasChanges ? 1 : 0.4)
                }

                Text("I want to learn")
                    .padding(.top, 30)

                TextField("Swift", text: $subject)

                Divider()

                Text("I want to learn it in a")
                    .padding(.top, 16)

                DurationPicker(selected: $duration)

                Spacer()
            }
            .padding()

            // رسالة التأكيد
            if showAlert {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .onTapGesture { showAlert = false }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Update goal")
                        .font(.headline)

                    Text("If you update now, your streak will start over.")
                        .foregroundStyle(.secondary)

                    HStack {
                        Button {
                            showAlert = false
                        } label: {
                            Text("Dismiss")
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(.systemGray4))
                                .clipShape(Capsule())
                        }

                        Button {
                            vm.saveGoal(subject: subject, duration: duration)
                            dismiss()
                        } label: {
                            Text("Update")
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.orange)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.top, 8)
                }
                .padding()
                .frame(maxWidth: 300)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 28))
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            // يعرض الهدف الحالي
            subject = vm.subject
            duration = vm.duration
        }
    }
}

#Preview {
    NavigationStack {
        ChangeLearningGoalView()
    }
    .environmentObject(LearningViewModel())
    .preferredColorScheme(.dark)
}
