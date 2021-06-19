//
//  CryptoViewModal.swift
//  Spoton-Test
//
//  Created by Navroz on 19/06/21.
//

import Combine
import Alamofire
import Foundation
class CryptoViewModal: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()
    private let network: NetworkingConfiguration
    private let endPoint: EndPointConfiguration
    private var timer: TenSecondTimer?
    
    @Published var stocks: [Stock]?
    
    init(endPoint: EndPointConfiguration = EndPoint(),
         network: NetworkingConfiguration = Networking(),
         timer: TenSecondTimer? = TenSecondTimer()) {
        self.network = network
        self.endPoint = endPoint
        self.timer = timer
        fetchStocks()
        setupTimer()
    }
    
    private func fetchStocks() {
        network.request(endPoint.path, method: endPoint.httpMethod)
            .sink { [weak self] (response: Result<StockContainer, AFError>) in
                switch response {
                case .success(let value):
                    self?.stocks = value.data
                case .failure(let error):
                    // TODO: Handle error
                    print(error)
                }
            }.store(in: &subscriptions)
    }
    
    private func setupTimer() {
        TenSecondTimer().$totalRequestTriggerd.sink { [weak self] _ in
            self?.fetchStocks()
        }.store(in: &subscriptions)
    }
}

class TenSecondTimer: ObservableObject {
    @Published var totalRequestTriggerd = 0
    
    lazy var timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in self.totalRequestTriggerd += 1 }
    init() { timer.fire() }
}
