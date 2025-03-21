//
//  ViewModel.swift
//  Money
//
//  Created by Priyansh on 21/02/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class CryptoViewModel: ObservableObject {
    @Published var coins = [CoinModel]()
    @Published var topCoins = [CoinModel]()
    @Published var wishlist = [CoinModel]()
    @Published var portfolio = [PortfolioItem]()
    
    private let db = Firestore.firestore()
    private var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    struct PortfolioItem: Identifiable, Codable {
        var id: String { coin.id }
        var coin: CoinModel
        var quantity: Double
        var currentHoldingsValue: Double {
            let holdings = coin.currentHoldings ?? 0
            let price = coin.currentPrice
            
            if holdings > 0 && price > 0 {
                return holdings * price
            } else {
                return 0
            }
        }
    }
    
    init() {
        loadData()
        loadWishlist()
        loadPortfolio()
    }
    
    //MARK: Coin data management
    
    func loadData() {
        Task {
            do {
                let fetchedCoins = try await fetchCoinData()
                let desiredSymbols = ["usdt", "btc", "sol", "eth", "doge", "steth", "trump"]
                let filteredCoins = fetchedCoins.filter { desiredSymbols.contains($0.symbol) }
                DispatchQueue.main.async {
                    self.coins = fetchedCoins
                    self.topCoins = filteredCoins
                }
            } catch {
                print("DEBUG: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchCoinData() async throws -> [CoinModel] {
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=inr"
        guard let url = URL(string: urlString) else {
            throw cryptoAPIError.invalidURL
        }
        
        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            return try JSONDecoder().decode([CoinModel].self, from: cachedResponse.data)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([CoinModel].self, from: data)
        } catch {
            print("DEBUG: \(error.localizedDescription)")
            throw cryptoAPIError.fetchingError
        }
    }
    
    enum cryptoAPIError: Error {
        case invalidURL
        case fetchingError
        case userNotAuthenticated
        case firestoreError
    }
    
    //MARK: Wishlist management
    
    func addToWishlist(coin: CoinModel) {
        if !wishlist.contains(where: { $0.id == coin.id }) {
            wishlist.append(coin)
        }
        saveWishlist()
    }
    
    func removeFromWishlist(coin: CoinModel) {
        wishlist.removeAll(where: { $0.id == coin.id })
        saveWishlist()
    }
    
    func loadWishlist() {
        guard let userId = userId else {
            print("DEBUG: User not authenticated")
            return
        }
        
        db.collection("users").document(userId).collection("wishlist").getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("DEBUG: Error fetching wishlist: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("DEBUG: No wishlist documents found")
                return
            }
            
            self.wishlist = documents.compactMap { document in
                try? document.data(as: CoinModel.self)
            }
        }
    }
    
    private func saveWishlist() {
        guard let userId = userId else {
            print("DEBUG: User not authenticated")
            return
        }
        
        let wishlistRef = db.collection("users").document(userId).collection("wishlist")
        deleteCollection(collection: wishlistRef) { [weak self] success in
            guard let self = self, success else { return }
            
            // Add new wishlist items
            for coin in self.wishlist {
                do {
                    try wishlistRef.document(coin.id).setData(from: coin)
                } catch {
                    print("DEBUG: Error saving wishlist item: \(error.localizedDescription)")
                }
            }
        }
    }
    
    //MARK: Portfolio management
    
    func addToPortfolio(coin: CoinModel, coinCount: Double) {
        if let index = portfolio.firstIndex(where: { $0.coin.id == coin.id }) {
            portfolio[index].quantity += coinCount
            portfolio[index].coin.currentHoldings = portfolio[index].quantity
        } else {
            var updatedCoin = coin
            updatedCoin.currentHoldings = coinCount
            portfolio.append(PortfolioItem(coin: updatedCoin, quantity: coinCount))
        }
        
        savePortfolio()
    }
    
    func removeFromPortfolio(coin: CoinModel, coinCount: Double) {
        if let index = portfolio.firstIndex(where: {$0.coin.id == coin.id}) {
            if portfolio[index].quantity >= coinCount {
                portfolio[index].quantity -= coinCount
                portfolio[index].coin.currentHoldings = portfolio[index].quantity
            }
            if portfolio[index].quantity == 0 {
                portfolio.removeAll(where: {$0.coin.id == coin.id})
            }
        }
        savePortfolio()
    }
    
    func updatePortfolio(coin: CoinModel, newQuantity: Double) {
        if let index = portfolio.firstIndex(where: { $0.coin.id == coin.id }) {
            if newQuantity > 0 {
                portfolio[index].quantity = newQuantity
                portfolio[index].coin.currentHoldings = newQuantity
            } else {
                portfolio.remove(at: index)
            }
        }
        savePortfolio()
    }
    
    func loadPortfolio() {
        guard let userId = userId else {
            print("DEBUG: User not authenticated")
            return
        }
        
        db.collection("users").document(userId).collection("portfolio").getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("DEBUG: Error fetching portfolio: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("DEBUG: No portfolio documents found")
                return
            }
            
            self.portfolio = documents.compactMap { document in
                try? document.data(as: PortfolioItem.self)
            }
        }
    }
    
    private func savePortfolio() {
        guard let userId = userId else {
            print("DEBUG: User not authenticated")
            return
        }
        
        // First, delete existing portfolio items
        let portfolioRef = db.collection("users").document(userId).collection("portfolio")
        deleteCollection(collection: portfolioRef) { [weak self] success in
            guard let self = self, success else { return }
            
            // Add new portfolio items
            for item in self.portfolio {
                do {
                    try portfolioRef.document(item.id).setData(from: item)
                } catch {
                    print("DEBUG: Error saving portfolio item: \(error.localizedDescription)")
                }
            }
        }
    }
    
    //MARK: Bookmark management
    
    func loadBookmarkState(coin: CoinModel) -> Bool {
        guard let userId = userId else {
            print("DEBUG: User not authenticated")
            return false
        }
        return wishlist.contains(where: { $0.id == coin.id })
    }
    
    func saveBookmarkState(coin: CoinModel) {
        addToWishlist(coin: coin)
    }
    
    func removeBookmarkState(coin: CoinModel) {
        removeFromWishlist(coin: coin)
    }
    
    private func deleteCollection(collection: CollectionReference, completion: @escaping (Bool) -> Void) {
        collection.limit(to: 50).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("DEBUG: Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }
            
            guard !documents.isEmpty else {
                completion(true)
                return
            }
            
            let batch = self.db.batch()
            
            documents.forEach { document in
                batch.deleteDocument(document.reference)
            }
            
            batch.commit { [weak self] error in
                guard let self = self else { return }
                
                if let error = error {
                    print("DEBUG: Error removing documents: \(error)")
                    completion(false)
                    return
                }
                
                self.deleteCollection(collection: collection, completion: completion)
            }
        }
    }
}
