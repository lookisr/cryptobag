//
//  Assembler.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 24.04.2023.
//

import Foundation
import UIKit


class MainModuleAssembly {
    static let shared: MainModuleAssembly = .init()
    class func configureModule() -> UIViewController {
        let dataModule = DataModel()
        let presenter = MainPresenter(dataService: dataModule)
        let view = MainViewController(presenter: presenter)
        view.presenter = presenter
        presenter.mainView = view
        presenter.router = MainRouter()
        presenter.router?.homeView = view

        return view
    }
    
    class func configureStockScreen(ticker: Ticker) -> UIViewController {
        let presenter = StockViewPresenter()
        let view = StockViewController(ticker: ticker, presenter: presenter)
        view.presenter = presenter
        presenter.mainView = view
        presenter.router = MainRouter()
        return view
    }
    class func configureProfileScreen() -> UIViewController {
        let view = ProfileViewController()
        let presenter = ProfilePresenter(view: view)
        return view
    }
    
    class func configurePortfolioScreen() -> UIViewController {
        let view = PortfolioView()
        let presenter = PortfolioPresenter()
        presenter.portfolioView = view
        view.presenter = presenter
        return view
    }
    func setupTabBar() -> UITabBarController {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return UITabBarController()
        }

        let tabBarController = UITabBarController()

        // Create and configure your view controllers for the tab bar
        let viewController1 = MainModuleAssembly.configureModule()
        let viewController2 = MainModuleAssembly.configureProfileScreen()
        let viewController3 = MainModuleAssembly.configurePortfolioScreen()
        // Создание навигационных контроллеров
        let navigationController1 = UINavigationController(rootViewController: viewController1)
        let navigationController2 = UINavigationController(rootViewController: viewController2)
        let navigationController3 = UINavigationController(rootViewController: viewController3)
        navigationController1.navigationBar.isHidden = true
        navigationController2.navigationBar.isHidden = true
        navigationController3.navigationBar.isHidden = true
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.shadowImage = UIImage()
        tabBarController.tabBar.layer.borderWidth = 0.3
        tabBarController.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        viewController1.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        viewController2.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        viewController3.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "latch.2.case"), selectedImage: UIImage(systemName: "latch.2.case.fill"))

        // Установка навигационных контроллеров в качестве viewControllers
        tabBarController.viewControllers = [navigationController1, navigationController2, navigationController3]

        return tabBarController
    }
}
