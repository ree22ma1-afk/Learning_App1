import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: LearningViewModel

    var body: some View {
        if vm.hasOnboarded {
            ActivityView()
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LearningViewModel())
        .preferredColorScheme(.dark)
}
