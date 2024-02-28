//
//  OrderPresenter.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 28.02.2024.
//

import Foundation


// MARK: - OrderPresenter
final class OrderPresenter: OrderPresentable {


    // MARK: - Properties
    weak var view: OrderViewProtocol?
    var interactor: OrderInteractorProtocol
    var router: OrderRouterProtocol

    // MARK: - Public API
    init(view: OrderViewProtocol? = nil,
         interactor: OrderInteractorProtocol = OrderInteractor(),
         router: OrderRouterProtocol = OrderRouter()) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func payForOrder(_ order: [OrderModel]) {
        router.payFor(order)
    }
}

// MARK: - OrderPresenterServiceInteractable
extension OrderPresenter: OrderPresenterServiceInteractable {

    func didTapPay(_ order: [OrderModel]) {
        interactor.payFor(order)
    }
}
