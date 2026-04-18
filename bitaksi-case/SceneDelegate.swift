//
//  SceneDelegate.swift
//  bitaksi-case
//
//  Created by Semih Özsoy on 15.04.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let storyboard = UIStoryboard(name: "HomeViewController", bundle: nil)
        guard let homeVC = storyboard.instantiateInitialViewController() as? HomeViewController else {
            fatalError("HomeViewController storyboard initial VC bulunamadı")
        }

        // VIPER wire-up
        let presenter = HomePresenter()
        let interactor = HomeInteractor()
        let router = HomeRouter()

        homeVC.presenter = presenter
        presenter.view = homeVC
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        let navController = UINavigationController(rootViewController: homeVC)
        router.navigationController = navController

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
