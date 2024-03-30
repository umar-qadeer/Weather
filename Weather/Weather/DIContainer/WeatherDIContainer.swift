
import Foundation

final class WeatherDIContainer {
    
    struct Dependencies {
        let networkService: NetworkService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Initializers
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repository
    
    private func makeWeatherRepository() -> WeatherRepositoryProtocol {
        return WeatherRepository(networkService: dependencies.networkService)
    }
    
    // MARK: - ViewModel
    
    private func makeWeatherViewModel() -> WeatherViewModel {
        return WeatherViewModel(weatherRepository: makeWeatherRepository())
    }
    
    // MARK: - ViewController
    
    func makeWeatherViewController(_ coordinator: AppCoordinator) -> WeatherViewController {
        let viewModel = makeWeatherViewModel()
        let viewController = WeatherViewController(coordinator, viewModel: viewModel)
        return viewController
    }
}
