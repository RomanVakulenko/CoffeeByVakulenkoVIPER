//
//  MenuInteractor.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 24.02.2024.
//

import Foundation

// MARK: - MenuInteractor
final class MenuInteractor {

    // MARK: - Public properties
    weak var presenter: MenuPresenterProtocol?
    var modelWithCoordinates: [LocationResponseModel] = []
    var menuModel: [OrderModel] = []

    // MARK: - Private properties
}


// MARK: - MenuInteractable
extension MenuInteractor: MenuInteractable {
    // возможно интерактор собирает модель набранного заказа
}

//extension MenuInteractor: MenuInteractorServiceRequester {
//
//
//
//    func makeUIModel(_ cafeId: Int) {
//
//        let cafeMenuService = StandardNetworkService(resourcePath: "/location/" + "\(cafeId)" + "/menu")
//
//        cafeMenuService.getMenuForChoosenCafe { [weak self] result in
//            guard let strongSelf = self else {return}
//            switch result {
//            case .success(let menus):
//                strongSelf.menuModel = menus
//                print(menus.description)
//
//                strongSelf.presenter?.
//            case .failure(let error):
//                strongSelf.presenter?.serviceFailedWithError(error)
//
//            }
//
//        }
//    }
//
//}
