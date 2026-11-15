import SwiftUI

@main
struct Learning_AppApp: App {
    // نسوي الـ ViewModel مرة وحدة هنا وننشره لكل الشاشات
    @StateObject private var vm = LearningViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .preferredColorScheme(.dark)   // الدارك مود
        }
    }
}
