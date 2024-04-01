
![Platform](https://img.shields.io/badge/Platform-iOS-orange.svg)
![Languages](https://img.shields.io/badge/Language-Swift-orange.svg)

iOS code challange.

## Demo
<img src="https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExZWhzaXI2dWUxcDZoZ3V2YjE2ZWJkZTA0bmg1YzJjYWg3ZzNuM2VrdCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/Jz4X3vN3hpJGkApnnZ/giphy.gif" width="222" height="480" />

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
