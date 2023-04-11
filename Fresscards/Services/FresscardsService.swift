

import Foundation

protocol FresscardsServiceable {
//    func fetchLatestPrice(forCountry code: String) async -> Result<DayPrice, RequestError>
//    func fetchPrices(forCountry code: String) async -> Result<[DayPrice], RequestError>
//    func fetchAppliances() async -> Result<[Appliance], RequestError>
    func fetchApiInfo() async -> Result<String, RequestError>
    func generateCards(request: NeuralRequest) async -> Result<NeuralResponse, RequestError>
}

struct FresscardsService: HTTPClient, FresscardsServiceable {
    
    func fetchApiInfo() async -> Result<String, RequestError> {
        return await getPrettyPrintedJSONResponse(endpoint: FresscardsEndpoint.apiInfo)
    }
    
    func generateCards(request: NeuralRequest) async -> Result<NeuralResponse, RequestError> {
        return await sendRequest(endpoint: FresscardsEndpoint.generate(request: request), responseModel: NeuralResponse.self)
    }
    
//    func fetchLatestPrice(forCountry code: String) async -> Result<DayPrice, RequestError> {
//        return await sendRequest(endpoint: EnergramEndpoint.latestPriceForCountry(countryCode: code), responseModel: DayPrice.self)
//    }
//
//    func fetchPrices(forCountry code: String) async -> Result<[DayPrice], RequestError> {
//        return await sendRequest(endpoint: EnergramEndpoint.pricesForCountry(countryCode: code), responseModel: [DayPrice].self)
//    }
//
//    func fetchAppliances() async -> Result<[Appliance], RequestError> {
//        return await sendRequest(endpoint: EnergramEndpoint.appliances, responseModel: [Appliance].self)
//    }
    
}
