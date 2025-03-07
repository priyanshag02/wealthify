//
//  ViewModel.swift
//  Money
//
//  Created by Priyansh on 21/02/25.
//

import Foundation

class CryptoViewModel: ObservableObject {
    @Published var coins = [CoinModel]()
    @Published var topCoins = [CoinModel]()
    @Published var wishlist = [CoinModel]()
    @Published var portfolio = [PortfolioItem]()
    
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
                let desiredSymbols = ["usdt", "btc", "sol", "eth", "doge"]
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
        if let data = UserDefaults.standard.data(forKey: "wishlist"),
           let savedWishlist = try? JSONDecoder().decode([CoinModel].self, from: data) {
            wishlist = savedWishlist
        }
    }
    
    private func saveWishlist() {
        if let data = try? JSONEncoder().encode(wishlist) {
            UserDefaults.standard.set(data, forKey: "wishlist")
        }
    }
    
    //MARK: Portfolio management
    
    func addToPortfolio(coin: CoinModel, coinCount: Double) {
        if coin.currentPrice <= 0 {
                print("DEBUG: Invalid price for coin \(coin.symbol). Cannot add to portfolio.")
                return
            }
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
        if let data = UserDefaults.standard.data(forKey: "portfolio"),
           let savedPortfolio = try? JSONDecoder().decode([PortfolioItem].self, from: data) {
            portfolio = savedPortfolio
        }
    }
    
    private func savePortfolio() {
        if let data = try? JSONEncoder().encode(portfolio) {
            UserDefaults.standard.set(data, forKey: "portfolio")
        }
    }
    
    //MARK: Bookmark management
    
    func loadBookmarkState(coin: CoinModel) -> Bool  {
        let bookmarkedCoins = UserDefaults.standard.array(forKey: "bookmarked") as? [String] ?? []
        return bookmarkedCoins.contains(coin.id)
    }

    func saveBookmarkState(coin: CoinModel) {
        var bookmarkedCoins = UserDefaults.standard.array(forKey: "bookmarked") as? [String] ?? []
        if !bookmarkedCoins.contains(coin.id) {
            bookmarkedCoins.append(coin.id)
            UserDefaults.standard.set(bookmarkedCoins, forKey: "bookmarked")
        }
    }

    func removeBookmarkState(coin: CoinModel) {
        var bookmarkedCoins = UserDefaults.standard.array(forKey: "bookmarked") as? [String] ?? []
        if let index = bookmarkedCoins.firstIndex(of: coin.id) {
            bookmarkedCoins.remove(at: index)
            UserDefaults.standard.set(bookmarkedCoins, forKey: "bookmarked")
        }
    }
}
