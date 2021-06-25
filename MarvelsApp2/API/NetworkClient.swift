
import Alamofire
import Foundation

class NetworkClient {
  
    private let baseUrl = "https://gateway.marvel.com"
    private let charasthersPath = "/v1/public/characters"
    
    private lazy var timestamp: Int = {
        return Int(Date().timeIntervalSince1970)
    }()
 
    private lazy var hash: String = {
        return md5Hash("\(timestamp)\(privtaeKey)\(publicKey)")
    }()

    init() {
        
    }
    func getCharacters(
        completion: @escaping (Result<CharacterResponse, NetworkError>) -> Void )
          {
        AF.request(
            "\(baseUrl)\(charasthersPath)",
            method: .get,
            parameters: [
              "limit": 100,
              "offset": 0,
              "apikey": publicKey,
              "hash": hash,
              "ts": timestamp
                ]
               ).validate(statusCode: 200 ..< 299).responseJSON { serverResponse in
                guard serverResponse.error == nil else {
                    completion(.failure(.serverError("Ha ocurriod un error \(serverResponse.error?.localizedDescription ?? "")")))
                  return
                }
                guard let secureData = serverResponse.data else {
                    completion(.failure(.dataError("Ha ocurriso algun error y datos que no existen")))
                    return
                }
                           do {
                               let json = try JSONDecoder().decode(CharacterResponse.self, from: secureData)
                            completion(.success(json))
                         } catch {
                            completion(.failure(.serializationError("Error: Trying to convert JSON data to string")))
                               return
                           }
               }
    }
}
enum NetworkError: Error, LocalizedError {
    case serverError(String)
    case dataError(String)
    case serializationError(String)
    
    public var errorDescripcion: String? {
        switch self {
        case .serverError(let descripcion):
            return descripcion
        case.dataError(let descripcion):
            return descripcion
        case .serializationError(let description):
            return description
        }
    }

}
struct CharacterResponse: Codable {
    var code: Int?
    var status: String?
    var copyright: String?
    var attributionText: String?
    var attributionHTML: String?
    var data: CharacterData?
    var etag: String?
}
struct CharacterData: Codable {
    var offset: Int?
    var limit: Int?
    var total: Int?
    var count: Int?
    var results: [CharacterResult]?
}
struct CharacterResult: Codable {
    var id: Int?
    var name: String?
    var description: String?
    var modified: String?
    var resourceURI: String?
    var urls: [CharacterUrl]?
    var thumbnail: Thumbnail?
    var comics: Comics?
    var stories: Stories?
    var events: Events?
    var series: Series?
}
struct CharacterUrl: Codable {
    var type: String?
    var url: String?
}
struct Thumbnail: Codable {
    var path: String?
    var thumbExtension: String?
    private enum CodingKeys: String, CodingKey {
        case path
        case thumbExtension = "extension"
    }
}
struct Comics: Codable {
    var available: Int?
    var returned: Int?
    var collectionURI: String?
    var items: [ComicItem]?
}
struct ComicItem: Codable {
    var resourceURI: String?
    var name: String?
}
struct Stories: Codable {
    var available: Int?
    var returned: Int?
    var collectionURI: String?
    var items: [StorieItem]?
}
struct StorieItem: Codable {
    var resourceURI: String?
    var name: String?
    var type: String?
}
struct Events: Codable {
    var available: Int?
    var returned: Int?
    var collectionURI: String?
    var items: [EventItem]?
}
struct EventItem: Codable {
    var resourceURI: String?
    var name: String?
}
struct Series: Codable {
    var available: Int?
    var returned: Int?
    var collectionURI: String?
    var items: [SerieItem]?
}
struct SerieItem: Codable {
    var resourceURI: String?
    var name: String?
}

