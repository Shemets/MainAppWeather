// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let searchResponse = try? newJSONDecoder().decode(SearchResponse.self, from: jsonData)

import Foundation

// MARK: - SearchResponseElement
struct SearchResponseElement: Decodable {
    var name: String
    var country: String
    var lat: Double
    var lon: Double
}

//typealias SearchResponse = [SearchResponseElement]
