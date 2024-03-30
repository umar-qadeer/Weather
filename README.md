
![Platform](https://img.shields.io/badge/Platform-iOS-orange.svg)
![Languages](https://img.shields.io/badge/Language-Swift-orange.svg)

iOS code challange.

## Demo
<img src="https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExYXM3NzY3MzVwMW5ma2hhZ3h0ancweHAxdHUzdzd5dmhwYXZzNTYweiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/HUkL0znTaThuR2rXyJ/giphy.gif" width="222" height="480" />
<img src="https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExYzdydjUwM3AzN3U2eTJoaXhoeHZ0aDVtc3Fjb2w1YndmYTlyeGU3byZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/KO7mDuPRnLdV5Wcjnu/giphy.gif" width="222" height="480" />

## Features

- [x] Implemented using MVVM-C with DIContainers and Repository
- [x] Network Requests using URLSession
- [x] HTTP Response Validation
- [x] Zero warnings
- [x] No Dependencies
- [x] Day and night mode UI

## Requirements

- iOS 16.0+
- Xcode 15.2+
- Swift 5+

## Design Pattern: Model-View-ViewModel Coordinator (MVVM - C)
is a structural design pattern that separates objects into three distinct groups:
- #### Model 
  - Contains the data models of the application
- #### View
  - View layer contains the UI (UIViewController).
- #### ViewModel
  - The communication layer between model and views. It also contains the business logic.
- ### Coordinator
  - Implemented coordinator pattern for the navigation in the application.
  
- ### Coding flow
    - ViewController -> ViewModel -> Repository -> NetworkLayer.
    

## Installation

### Clone Or Download Repository

- Clone the project and open 'Weather.xcodeproj'.
