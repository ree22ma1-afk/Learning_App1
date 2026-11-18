# Learning App

Learning App is an iOS app that helps you build a daily learning habit. You choose what you want to learn and for how long, then log every day you learn, and use a limited number of freezes on the days you can't.

## Main Features

In the current build, users can:

- Choose **what they want to learn** and the **duration** (Week, Month, or Year) when they start.
- **Log today as learned** with one tap. A day can only be logged once.
- **Freeze a day** when they can't learn, with a limited number of freezes (Week: 2, Month: 8, Year: 96).
- See the **current week** with learned days in orange, frozen days in blue, and today highlighted.
- Track the number of **learned days** and **frozen days**.
- Get a **"Well done!"** screen when they reach their goal, or a message if the duration ends before they reach it.
- **Set a new goal** after finishing the previous one.
- **Change the goal** at any time. A confirmation alert warns that the streak will start over.
- Open a **calendar for the full year** to see all previous learned and frozen days (view only).
- Keep their goal and logged days saved on the device.

## Screenshots

<img width="1206" height="2622" alt="Screenshot iPhone 17 07-06-1448 AH at 11 02 06 AM" src="https://github.com/user-attachments/assets/a7106507-32d8-40c9-b49f-0821d49c06fb" />
<img width="1206" height="2622" alt="Screenshot iPhone 17 07-06-1448 AH at 10 57 56 AM" src="https://github.com/user-attachments/assets/c60b5ea9-402c-4351-8e03-f1cc5c69b101" />
<img width="1206" height="2622" alt="Screenshot iPhone 17 07-06-1448 AH at 10 57 18 AM" src="https://github.com/user-attachments/assets/2068c2c2-f8ae-4f0d-b17d-aaaee048828e" />





- Swift
- SwiftUI
- MVVM architecture
- UserDefaults (to save the goal and logged days)
- Xcode

## Project Structure (MVVM)

```
Learning_App
├── Model
│   └── LearningModel.swift          // Duration, day status, goal state
├── ViewModel
│   └── LearningViewModel.swift      // Data, calculations, and actions
├── View
│   ├── OnboardingView.swift
│   ├── ActivityView.swift
│   ├── GoalCompletionView.swift
│   ├── ChangeLearningGoalView.swift
│   ├── ActivitiesCalendarView.swift
│   └── Views.swift                  // Shared views (DurationPicker, DayCircle)
├── ContentView.swift                // Chooses which screen to show
└── Learning_AppApp.swift            // App entry point
```

- **Model:** the types used by the app.
- **ViewModel:** holds the goal and the logged days, saves them, and has the actions used by the buttons.
- **View:** the screens. They only display data and call the ViewModel.

## How to Run

1. Clone the repository.
2. Open `Learning_App.xcodeproj` in Xcode.
3. Choose an iPhone simulator.
4. Press **Run**.

## Author

Reema Alsahali


