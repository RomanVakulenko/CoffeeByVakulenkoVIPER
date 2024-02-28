//
//  MenuService.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 14.02.2024.
//


import UIKit
import Alamofire

protocol MenuServiceProtocol: AnyObject {
    func makeCoffeeModelWithFoto(for models: [MenuModel],
                                 completion: @escaping (Result<[OrderModel], Error>) -> Void)
}

class MenuService: MenuServiceProtocol {
    private var coffeeModelsWithPhoto: [OrderModel] = []

    func makeCoffeeModelWithFoto(for models: [MenuModel],
                                 completion: @escaping (Result<[OrderModel], Error>) -> Void) {
        let group = DispatchGroup()

        for menu in models {
            group.enter()
            AF.download(menu.imageURL).responseData { response in
                defer { group.leave() } //defer выполнит код последним и гарантирует, что выйдем из группы

                switch response.result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        if let imageData = image.pngData() {
                            let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                            let fileName = "\(menu.name).png"
                            let fileURL = documentDir.appendingPathComponent(fileName)

                            do {
                                try imageData.write(to: fileURL)
                                self.coffeeModelsWithPhoto.append(
                                    OrderModel(id: menu.id,
                                              coffeeName: menu.name,
                                              imageURL: fileURL.path,
                                              quantity: 0,
                                              price: menu.price))
                            } catch {
                                completion(.failure(error))
                            }
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

        group.notify(queue: .main) {
            completion(.success(self.coffeeModelsWithPhoto))
        }
    }
}
