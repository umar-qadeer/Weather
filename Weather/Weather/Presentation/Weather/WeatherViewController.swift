
import UIKit
import CoreLocation

protocol WeatherViewControllerCoordinationDelegate: AnyObject {
}

final class WeatherViewController: UIViewController {
    
    // MARK: - Properties
    
    private weak var coordinator: WeatherViewControllerCoordinationDelegate?
    private var viewModel: WeatherViewModel
    private var locationManager: CLLocationManager?
    
    private lazy var searchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 70
        stackView.alignment = .center
        stackView.isHidden = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return stackView
    }()
    
    private lazy var searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return imageView
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.borderStyle = .none
        textField.returnKeyType = .search
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return textField
    }()
    
    private lazy var textFieldBottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.circlepath"), for: .normal)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
        button.setPreferredSymbolConfiguration(largeConfig, forImageIn: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var weatherStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 50
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var weatherInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        return label
    }()
    
    private lazy var dayTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .regular, scale: .large)
        let colorConfig = UIImage.SymbolConfiguration(paletteColors: [.white, .systemYellow])
        let coloredLargedConfig = largeConfig.applying(colorConfig)
        imageView.preferredSymbolConfiguration = coloredLargedConfig
        return imageView
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var tempratureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40, weight: .bold)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var infoSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 40).isActive = true
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    private lazy var weatherDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 30
        return stackView
    }()
    
    private lazy var sunriseView: WeatherDetailView = {
        let view = WeatherDetailView()
        return view
    }()
    
    private lazy var firstSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return view
    }()
    
    private lazy var windView: WeatherDetailView = {
        let view = WeatherDetailView()
        return view
    }()
    
    private lazy var secondSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return view
    }()
    
    private lazy var sunsetView: WeatherDetailView = {
        let view = WeatherDetailView()
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .systemGray3
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var noDataView: NoWeatherDataView = {
        let view = NoWeatherDataView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
    
    init(_ coordinator: WeatherViewControllerCoordinationDelegate, viewModel: WeatherViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        // Initialize location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        // Resgiter notification
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Unresgiter notification
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Setup methods
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubviews(searchStackView, weatherStackView, noDataView, activityIndicator)
        searchStackView.addArrangedSubviews(searchImageView, searchTextField, refreshButton)
        searchStackView.setCustomSpacing(0, after: searchImageView)
        searchTextField.addSubview(textFieldBottomLine)
        weatherStackView.addArrangedSubviews(weatherInfoStackView, infoSeparatorView, weatherDetailStackView)
        weatherInfoStackView.addArrangedSubviews(titleStackView, weatherImageView, descriptionStackView)
        titleStackView.addArrangedSubviews(cityNameLabel, dayTimeLabel)
        descriptionStackView.addArrangedSubviews(tempratureLabel, descriptionLabel)
        weatherDetailStackView.addArrangedSubviews(sunriseView, windView, sunsetView)
        weatherDetailStackView.addSubviews(firstSeparatorView, secondSeparatorView)
    }
    
    private func setupConstraints() {
        let layoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            searchStackView.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 15),
            searchStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            textFieldBottomLine.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
            textFieldBottomLine.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor),
            textFieldBottomLine.bottomAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            
            weatherStackView.topAnchor.constraint(equalTo: searchStackView.bottomAnchor, constant: 50),
            weatherStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherStackView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -30),
            
            firstSeparatorView.leadingAnchor.constraint(equalTo: sunriseView.trailingAnchor, constant: 15),
            firstSeparatorView.bottomAnchor.constraint(equalTo: weatherDetailStackView.bottomAnchor, constant: -15),
            
            secondSeparatorView.leadingAnchor.constraint(equalTo: windView.trailingAnchor, constant: 15),
            secondSeparatorView.bottomAnchor.constraint(equalTo: weatherDetailStackView.bottomAnchor, constant: -15),
            
            activityIndicator.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor, constant: 30),
            
            noDataView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noDataView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            noDataView.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor)
        ])
    }
    
    // MARK: - Selectors
    
    @objc private func refreshButtonTapped() {
        guard let city = viewModel.weather?.cityName else { return }
        viewModel.getCurrentWeather(for: city)
    }
    
    @objc private func applicationDidBecomeActive() {
        if locationManager?.authorizationStatus == .authorizedWhenInUse {
            noDataView.isHidden = true
            locationManager?.startUpdatingLocation()
        }
    }
    
    // MARK: - Helper methods
    
    private func getDayTime(from date: Date, timezone: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: timezone)
        dateFormatter.dateFormat = Constants.DateFormat.dayTime
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: date)
    }
    
    private func getHour(from date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormat.hour
        let stringHour = dateFormatter.string(from: date)
        // it is safe to force unwrap here due to hour conversion surity
        return Int(stringHour)!
    }
    
    private func getBackgroundColor(for time: Date) -> UIColor {
        let hour = getHour(from: time)
        return (1...18).contains(hour) ? UIColor(resource: .dayBackground) : UIColor(resource: .nightBackground)
    }
    
    private func getForegroundColor(for time: Date) -> UIColor {
        let hour = getHour(from: time)
        return (1...18).contains(hour) ? .black : .white
    }
}

extension WeatherViewController: WeatherViewModelToViewDelegate {
    
    func updateUI() {
        guard let weather = viewModel.weather,
              let timezone = weather.timezone,
              let weatherDetail = weather.detail,
              let temprature = weather.temprature,
              let windSpeed = weather.windSpeed else { return }
        
        let date = Date()
        view.backgroundColor = getBackgroundColor(for: date)
        let foregroundColor = getForegroundColor(for: date)
        
        searchStackView.isHidden = false
        searchImageView.tintColor = foregroundColor
        searchTextField.tintColor = foregroundColor
        searchTextField.textColor = foregroundColor
        searchTextField.attributedPlaceholder = NSAttributedString(string: Strings.Weather.searchCityPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: foregroundColor])
        textFieldBottomLine.backgroundColor = foregroundColor
        
        refreshButton.tintColor = foregroundColor
        
        cityNameLabel.textColor = foregroundColor
        dayTimeLabel.textColor = foregroundColor
        tempratureLabel.textColor = foregroundColor
        descriptionLabel.textColor = foregroundColor
        
        cityNameLabel.text = weather.cityName
        dayTimeLabel.text = getDayTime(from: date, timezone: timezone)
        
        weatherImageView.image = UIImage(systemName: weatherDetail.getWeatherImage())
        
        tempratureLabel.text = "\(temprature)°C"
        descriptionLabel.text = weatherDetail.description
        
        infoSeparatorView.backgroundColor = foregroundColor.withAlphaComponent(0.5)
        
        sunriseView.populate(image: UIImage(systemName: "sunrise.fill"), title: Strings.Weather.sunrise, value: weather.sunrise, color: foregroundColor)
        firstSeparatorView.backgroundColor = foregroundColor.withAlphaComponent(0.5)
        windView.populate(image: UIImage(systemName: "wind"), title: Strings.Weather.wind, value: "\(String(format: "%0.2f", windSpeed)) m/s", color: foregroundColor)
        secondSeparatorView.backgroundColor = foregroundColor.withAlphaComponent(0.5)
        sunsetView.populate(image: UIImage(systemName: "sunset.fill"), title: Strings.Weather.sunset, value: weather.sunset, color: foregroundColor)
    }
    
    func showError(error: Error) {
        AlertBuilder.showfailureAlertWithMessage(message: error.localizedDescription, on: self)
    }
    
    func showLoading(_ loading: Bool) {
        loading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        default:
            AlertBuilder.showAlertWithTitle(title: Strings.Alert.locaitonDeniedTitle, message: Strings.Alert.locaitonDeniedMessage, confirmButtonTitle: Strings.Alert.openSettings, confirmButtonHandler: { [weak self] in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    self?.noDataView.isHidden = false
                }
            }, shoulShowCancelButton: true, cancelButtonHandler: { [weak self] in
                self?.noDataView.isHidden = false
            }, on: self)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Stop updating location to conserve battery
        locationManager?.stopUpdatingLocation()
        
        // Get the most recent location
        guard let location = locations.last else { return }
        
        // Reverse geocode the location to get city name
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self else { return }
            
            if let error {
                AlertBuilder.showfailureAlertWithMessage(message: error.localizedDescription, on: self)
                return
            }
            
            if let city = placemarks?.first?.locality {
                viewModel.getCurrentWeather(for: city)
            } else {
                AlertBuilder.showfailureAlertWithMessage(message: Strings.Alert.cityNotFound, on: self)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        AlertBuilder.showfailureAlertWithMessage(message: error.localizedDescription, on: self)
    }
}

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text
        textField.text = nil
        view.endEditing(true)
        guard let city = text, city.trimmingCharacters(in: CharacterSet.whitespaces).count > 0 else { return true }
        viewModel.getCurrentWeather(for: city)
        return true
    }
}
