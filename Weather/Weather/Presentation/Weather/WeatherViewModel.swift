
import Foundation

protocol WeatherViewModelToViewDelegate: BaseViewModelToViewDelegate {
}

final class WeatherViewModel: BaseViewModel {
    
    // MARK: - Properties
    
    var weather: Weather?
    private let weatherRepository: WeatherRepositoryProtocol?
    weak var delegate: WeatherViewModelToViewDelegate?

    // MARK: - Initializers
    
    init(weatherRepository: WeatherRepositoryProtocol) {
        self.weatherRepository = weatherRepository
    }
    
    // MARK: - Methods
    
    func getCurrentWeather(for city: String) {
        delegate?.showLoading(true)
        
        weatherRepository?.getCurrentWeather(for: city, completion: { [weak self] result in
            self?.delegate?.showLoading(false)
            
            switch result {
            case .success(let weather):
                self?.weather = weather
                self?.delegate?.updateUI()
            case .failure(let error):
                self?.delegate?.showError(error: error)
            }
        })
    }
}

