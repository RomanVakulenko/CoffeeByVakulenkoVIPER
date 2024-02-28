//
//  MenuPresenter.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 24.02.2024.
//

import Foundation


// MARK: - MenuPresenter
final class MenuPresenter: MenuPresentable {

    // MARK: - Properties
    weak var view: MenuViewProtocol?
    var interactor: MenuInteractorProtocol
    var router: MenuRouterProtocol

    // MARK: - Init
    init(view: MenuViewProtocol? = nil,
         interactor: MenuInteractorProtocol = MenuInteractor(),
         router: MenuRouterProtocol = MenuRouter()) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - MenuPresenterServiceInteractable
extension MenuPresenter: MenuPresenterInteractable {

    func assembleOrderWith(order: [OrderModel]) {
        router.showTheOrder(order)
    }
}
