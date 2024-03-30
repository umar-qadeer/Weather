
import Foundation

struct WeatherDetail: Codable {
    
    var icon: String?
    var description: String?
    
    // Get SF symbol for weather status
    
    func getWeatherImage() -> String {
        
        switch icon {
        case "t01d", "t02d", "t03d", "t01n", "t02n", "t03n":
            return "cloud.bolt.rain.fill"
        case "t04d", "t04n", "t05d", "t05n":
            return "cloud.bolt.fill"
        case "d01d", "d01n", "d02d", "d02n", "d03d", "d03n":
            return "cloud.drizzle.fill"
        case "r01d", "r01n", "r02d", "r02n":
            return "cloud.rain.fill"
        case "r03d", "r03n":
            return "cloud.heavyrain.fill"
        case "f01d", "f01n", "r04d", "r04n", "r05d", "r05n", "r06d", "r06n":
            return "cloud.rain.fill"
        case "s01d", "s01n", "s02d", "s02n", "s03d", "s03n", "s04d", "s04n":
            return "cloud.snow.fill"
        case "s05d", "s05n":
            return "cloud.sleet.fill"
        case "a01d", "a01n", "a02d", "a02n", "a03d", "a03n", "a04d", "a04n", "a05d", "a05n", "a06d", "a06n":
            return "smoke.fill"
        case "c01d", "c01n":
            return "sun.max.fill"
        case "c02d", "c02n", "c03d", "c03n":
            return "cloud.sun.fill"
        case "c04d", "c04n":
            return "smoke.fill"
        default:
            return "cloud.fill"
        }
    }
}
