
import Foundation

protocol WeatherRepositoryProtocol: AnyObject {
    func getCurrentWeather(for city: String, completion: @escaping (Result<Weather?, Error>) -> Void)
}

final class WeatherRepository: WeatherRepositoryProtocol {
    
    // MARK: - Properties
    
    private let networkService: NetworkService
    
    // MARK: - Init
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    // MARK: - WeatherRepositoryProtocol
    
    func getCurrentWeather(for city: String, completion: @escaping (Result<Weather?, Error>) -> Void) {
        networkService.request(CurrentWeatherRequest(city: city), completion: completion)
    }
}
