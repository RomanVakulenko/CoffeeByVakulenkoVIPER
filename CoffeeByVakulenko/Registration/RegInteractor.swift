//
//  RegistrationInteractor.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 06.02.2024.
//  
//

import Foundation
import Alamofire

// MARK: - LoginInteractor
final class RegistrationInteractor: RegistrationInteractable {

    weak var presenter: RegistrationPresenterProtocol?
    var cafes: [CafeTableModelForUI] = []

    private let registerService, loginService, cafeService: StandardNetworkService
    private let userDefaults: CoffeeUserDefaults
    private let keychain: CoffeeKeychain
    private let distanceService: DistanceServiceProtocol
    private let mapper = DataMapper()

    init(registerService: StandardNetworkService = StandardNetworkService(resourcePath: "/auth/register"),
         loginService: StandardNetworkService = StandardNetworkService(resourcePath: "/auth/login"),
         cafeService: StandardNetworkService = StandardNetworkService(resourcePath: "/locations", authenticated: true),
         userDefaults: CoffeeUserDefaults = .shared,
         keychain: CoffeeKeychain = .shared,
         distanceService: DistanceServiceProtocol = DistanceService()) {
        self.registerService = registerService
        self.loginService = loginService
        self.cafeService = cafeService
        self.userDefaults = userDefaults
        self.keychain = keychain
        self.distanceService = distanceService
    }

    func makeUIModelWithDistanceFor(_ locations: [LocationResponseModel]) -> [CafeTableModelForUI] {
        distanceService.makeUIModelWithDistance(
            decodedModel: locations,
            locationManager: distanceService.locationManager) { cafesForUI in
                self.cafes = cafesForUI
            }
        return self.cafes
    }
}


// MARK: - Credentials handler
extension RegistrationInteractor: RegistrationInteractorCredentialsHandler {

    var doRememberUsername: Bool { userDefaults.isUsernameStored ?? true }
    var usernameFromStorage: String? { userDefaults.username }

    func storePassword(password: String?) {
        keychain.password = password
    }
}

// MARK: - Services
extension RegistrationInteractor: RegistrationInteractorServiceRequester {

    func register(username: String, password: String) {
        guard let hashedPasssword = Crypto.hash(message: password) else {
            fatalError("Unable to hash password")
        }

        let parameters: [String: Any] = [
            "login":   username,
            "password": hashedPasssword
        ]
        registerService.postWith(parameters) { [weak self] result in
//            DispatchQueue.main.async {
                guard let strongSelf = self else {return}
                switch result {
                case .failure(let error):
                    strongSelf.presenter?.serviceFailedWithError(error)

                case .success(_):
                    strongSelf.userDefaults.username = username
                    strongSelf.userDefaults.isUsernameStored = true
                    strongSelf.storePassword(password: hashedPasssword)
                    strongSelf.presenter?.didRegister()
                }
//            }
        }
    }

    func loginWith(username: String, password: String) {
        guard let hashedPasssword = Crypto.hash(message: password) else {
            fatalError("Unable to hash password")
        }
        if hashedPasssword == keychain.password {
            let parameters: [String: Any] = [
                "login":   username,
                "password": hashedPasssword
            ]

            loginService.postWith(parameters) { [weak self] result in
//                DispatchQueue.main.async {
                    guard let strongSelf = self else {return}
                    switch result {
                    case .failure(let error):
                        strongSelf.presenter?.serviceFailedWithError(error)

                    case .success(let loginModel):
                        strongSelf.keychain.token = loginModel.token
                        strongSelf.presenter?.didLogin()
                    }
//                }
            }
        }
    }

    func getLocations(username: String, password: String) {
        if let password = keychain.password {

            cafeService.getLocationsOfCafes() { [weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .failure(let error):
                    strongSelf.presenter?.serviceFailedWithError(error)

                case .success(let locations):
                    strongSelf.cafes = strongSelf.makeUIModelWithDistanceFor(locations)
                    do {
                        strongSelf.userDefaults.locations = try strongSelf.mapper.encode(from: locations)
                        strongSelf.presenter?.gotLocations(strongSelf.cafes, locations: locations)
                    } catch {
                        strongSelf.presenter?.serviceFailedWithError(MapperError.failParsed(reason: "Encoding error"))
                    }
                }

            }
        }
    }
}

