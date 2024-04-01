
import UIKit
import CoreLocation

protocol WeatherViewControllerCoordinationDelegate: AnyObject {
}

final class WeatherViewController: UIViewController {
    
    // MARK: - Properties
    
    private weak var coordinator: WeatherViewControllerCoordinationDelegate?
    private var viewModel: WeatherViewModel
    private var locationManager: CLLocationManager?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.refreshControl = refreshControl
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 50
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var searchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
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
    
    private lazy var spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return view
    }()
    
    private lazy var searchCancelButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.contentHorizontalAlignment = .left
        button.setTitle(Strings.Button.cancel, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.addTarget(self, action: #selector(searchCancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchTextFieldBottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
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
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .systemGray3
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
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
    
    // MARK: - Setup methods
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubviews(containerStackView, noDataView, activityIndicatorView)
        containerStackView.addArrangedSubviews(searchStackView, weatherStackView)
        searchStackView.addArrangedSubviews(searchImageView, searchTextField, spacerView, searchCancelButton)
        searchTextField.addSubview(searchTextFieldBottomLine)
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
            scrollView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: layoutGuide.heightAnchor),
            
            containerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            containerStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            containerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            
            searchTextFieldBottomLine.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
            searchTextFieldBottomLine.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor),
            searchTextFieldBottomLine.bottomAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            
            firstSeparatorView.leadingAnchor.constraint(equalTo: sunriseView.trailingAnchor, constant: 15),
            firstSeparatorView.bottomAnchor.constraint(equalTo: weatherDetailStackView.bottomAnchor, constant: -15),
            
            secondSeparatorView.leadingAnchor.constraint(equalTo: windView.trailingAnchor, constant: 15),
            secondSeparatorView.bottomAnchor.constraint(equalTo: weatherDetailStackView.bottomAnchor, constant: -15),
            
            noDataView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            noDataView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            noDataView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 30)
        ])
    }
    
    // MARK: - Selectors
    
    @objc private func didPullToRefresh() {
        guard let city = viewModel.weather?.cityName else { return }
        viewModel.getCurrentWeather(for: city)
    }
    
    @objc private func searchCancelButtonTapped() {
        view.endEditing(true)
    }
    
    @objc private func applicationDidBecomeActive() {
        if locationManager?.authorizationStatus == .authorizedWhenInUse {
            noDataView.isHidden = true
            locationManager?.startUpdatingLocation()
        }
    }
    
    // MARK: - Helper methods
    
    private func getStringDate(from date: Date, dateFormat: String, timeZoneIdentifier: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier)
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
    private func getBackgroundColor(for hour: Int) -> UIColor {
        return (5...18).contains(hour) ? UIColor(resource: .dayBackground) : UIColor(resource: .nightBackground)
    }
    
    private func getForegroundColor(for hour: Int) -> UIColor {
        return (5...18).contains(hour) ? .black : .white
    }
    
    private func setSearchCancelButtonHidden(isHidden: Bool) {
        UIView.animate(withDuration: 0.15) { [weak self] in
            self?.searchCancelButton.isHidden = isHidden
        }
    }
}

extension WeatherViewController: WeatherViewModelToViewDelegate {
    
    func updateUI() {
        refreshControl.endRefreshing()
        
        guard let weather = viewModel.weather,
              let timeZoneIdentifier = weather.timeZoneIdentifier,
              let weatherDetail = weather.detail,
              let temprature = weather.temprature,
              let windSpeed = weather.windSpeed else { return }
        
        let date = Date()
        let stringHour = getStringDate(from: date, dateFormat: Constants.DateFormat.hour, timeZoneIdentifier: timeZoneIdentifier)
        
        guard let hour = Int(stringHour) else { return }
        
        view.backgroundColor = getBackgroundColor(for: hour)
        let foregroundColor = getForegroundColor(for: hour)
        
        refreshControl.tintColor = foregroundColor
        
        searchStackView.isHidden = false
        searchImageView.tintColor = foregroundColor
        searchTextField.tintColor = foregroundColor
        searchTextField.textColor = foregroundColor
        searchTextField.attributedPlaceholder = NSAttributedString(string: Strings.Weather.searchCityPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: foregroundColor.withAlphaComponent(0.5)])
        searchTextFieldBottomLine.backgroundColor = foregroundColor
        
        cityNameLabel.textColor = foregroundColor
        dayTimeLabel.textColor = foregroundColor
        tempratureLabel.textColor = foregroundColor
        descriptionLabel.textColor = foregroundColor
        
        cityNameLabel.text = weather.cityName
        dayTimeLabel.text = getStringDate(from: date, dateFormat: Constants.DateFormat.dayTime, timeZoneIdentifier: timeZoneIdentifier)
        
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
        refreshControl.endRefreshing()
        AlertBuilder.showfailureAlertWithMessage(message: error.localizedDescription, on: self)
    }
    
    func showLoading(_ loading: Bool) {
        loading ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
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
        view.endEditing(true)
        guard let city = text, city.trimmingCharacters(in: CharacterSet.whitespaces).count > 0 else { return true }
        viewModel.getCurrentWeather(for: city)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setSearchCancelButtonHidden(isHidden: false)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setSearchCancelButtonHidden(isHidden: true)
        textField.text = nil
    }
}
