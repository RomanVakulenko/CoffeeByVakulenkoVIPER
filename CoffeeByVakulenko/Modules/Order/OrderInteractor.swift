//
//  OrderInteractor.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 28.02.2024.
//

import Foundation

// MARK: - OrderInteractor
final class OrderInteractor: OrderInteractable {
    // MARK: - Public properties
    weak var presenter: OrderPresenterProtocol?
    var order: [OrderModel] = []
}

extension OrderInteractor: OrderInteractorServiceRequester {
    func payFor(_ order: [OrderModel]) {
        print("Payed")
        presenter?.payForOrder(order)
    }
}
