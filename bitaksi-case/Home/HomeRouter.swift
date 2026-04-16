//
//  HomeRouter.swift
//  bitaksi-case
//
//  Created by Semih Özsoy on 15.04.2026.
//

import UIKit

protocol HomeRouterInterface: AnyObject {}

final class HomeRouter {
    var presenter: HomePresenterInterface?
    weak var navigationController: UINavigationController?
}

extension HomeRouter: HomeRouterInterface {
}
