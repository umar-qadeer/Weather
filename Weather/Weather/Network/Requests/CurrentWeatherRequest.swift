
import Foundation

struct CurrentWeatherRequest: DataRequest {
    
    var city: String

    var url: String {
        let baseURL: String = NetworkConstants.baseURL
        let path: String = NetworkConstants.EndPoints.currentWeather
        return baseURL + path
    }

    var method: HTTPMethod {
        .get
    }

    var queryItems: [String : String] {
        return [
            "city": city,
            "key": NetworkConstants.apiKey
        ]
    }

    func decode(_ data: Data) throws -> Weather? {
        let decoder = JSONDecoder()
        let response = try decoder.decode(WeatherResponse.self, from: data)
        return response.data?.first
    }
}
