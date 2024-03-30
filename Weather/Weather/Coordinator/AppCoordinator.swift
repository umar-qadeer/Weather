
import UIKit

class AppCoordinator: Coordinator {
    
    enum Destination {
        case weather
    }
    
    // MARK: - Properties
    
    private(set) var navigationController: UINavigationController?
    private var appDIContainer: AppDIContainer
    
    // MARK: - Initializer
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.appDIContainer = appDIContainer
    }
    
    // MARK: - Coordinator
    
    @discardableResult func start(from destination: Destination = .weather) -> UIViewController? {
        set(to: destination)
        return self.navigationController
    }
    
    @discardableResult func restart(from destination: Destination = .weather) -> UIViewController? {
        set(to: destination)
        return self.navigationController
    }
    
    func set(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.setViewControllers([viewController], animated: false)
    }
    
    func push(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func present(controller viewController: UIViewController) {
        navigationController?.present(viewController, animated: true)
    }
    
    func dismiss(animated: Bool = true, completion: @escaping () -> Void = {}) {
        self.navigationController?.dismiss(animated: animated, completion: completion)
    }
    
    func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .weather:
            let diContainer = appDIContainer.makeWeatherDIContainer()
            let viewController = diContainer.makeWeatherViewController(self)
            return viewController
        }
    }
}

extension AppCoordinator: WeatherViewControllerCoordinationDelegate {
}
