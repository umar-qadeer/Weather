
import Foundation

final class AppDIContainer {
    
    lazy var networkService: NetworkService = {
        return DefaultNetworkService()
    }()
    
    func makeWeatherDIContainer() -> WeatherDIContainer {
        let dependencies = WeatherDIContainer.Dependencies(networkService: networkService)
        return WeatherDIContainer(dependencies: dependencies)
    }
}
