//
//  YMapPresenter.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 23.02.2024.
//

import Foundation


// MARK: - YMapPresenter
final class YMapPresenter: YMapPresentable {

    // MARK: - Properties
    weak var view: YMapViewProtocol?
    var interactor: YMapInteractorProtocol
    var router: YMapRouterProtocol

    // MARK: - Public API
    init(view: YMapViewProtocol? = nil,
         interactor: YMapInteractorProtocol = YMapInteractor(),
         router: YMapRouterProtocol = YMapRouter()) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - Interactor
extension YMapPresenter: YMapPresenterServiceInteractable {

    func showMenu(_ menu: [OrderModel]) {
        Show.spinner.stopAnimating()
        router.showCafeMenu(menu, locations: interactor.modelWithCoordinates)
    }


    func didTapAtCafe(_ cafeId: Int) {
        interactor.getMenuForCafeId(cafeId)
    }
}

extension YMapPresenter: YMapPresenterServiceHandler {
    func serviceFailedWithError(_ error: Error) {
        view?.handleError(title: "Error", message: String(describing: error))
    }
}
