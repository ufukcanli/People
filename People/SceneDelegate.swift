//
//  SceneDelegate.swift
//  People
//
//  Created by Ufuk Canlı on 31.03.2023.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        let navigationController = UINavigationController(
            rootViewController: ListViewController()
        )
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
