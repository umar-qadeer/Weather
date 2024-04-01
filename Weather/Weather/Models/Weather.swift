
import Foundation

struct Weather: Codable {
    var temprature: Double?
    var cityName: String?
    var windSpeed: Double?
    var sunrise: String?
    var sunset: String?
    var timeZoneIdentifier: String?
    var clouds: Int?
    var detail: WeatherDetail?

    enum CodingKeys: String, CodingKey {
        case temprature = "temp"
        case cityName = "city_name"
        case windSpeed = "wind_spd"
        case sunrise
        case sunset
        case timeZoneIdentifier = "timezone"
        case clouds
        case detail = "weather"
    }
}
