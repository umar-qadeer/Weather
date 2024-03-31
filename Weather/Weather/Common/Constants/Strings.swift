
import Foundation

struct Strings {
    
    struct Weather {
        static let searchCityPlaceholder = "Search City Name"
        static let sunrise = "Sunrise"
        static let wind = "Wind"
        static let sunset = "Sunset"
    }
    
    struct Alert {
        static let success = "Success"
        static let error =  "Error"
        static let okay =  "Okay"
        static let cancel =  "Cancel"
        static let cityNotFound = "City name not found"
        static let locaitonDeniedTitle = "Allow permission to use your location"
        static let locaitonDeniedMessage = "Weather app needs access to your location to provide weather details"
        static let openSettings =  "Open Settings"
        static let permissionDescription =  "Please give location permission from settings app to fetch the weather the data."
    }
    
    struct Error {
        static let general = "Unexpected error occurred. Please try again."
        static let noInternet = "Please check your internet connection."
        static let apiError = "There is something wrong with the api."
        static let invalidQueryItems = "Invalid query params provided."
        static let invalidParameter = "Invalid parameter provided."
        static let invalidResponse = "Unable to handle the response."
        static let invalidEndpoint = "Invalid end point provided."
        static let noData = "Data not available."
    }
}
