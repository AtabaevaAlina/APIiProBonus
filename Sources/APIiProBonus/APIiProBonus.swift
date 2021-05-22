
import Foundation
import Combine

public class APIiProBonus {
    static let apiClient = APIClient()
    static let baseUrl = URL(string: "https://mp1.iprobonus.com/api/v3/")!
    static var cancellable: AnyCancellable? = nil
}

enum APIPath: String {
    case client = "clients/accesstoken"
    case clientInfo = "ibonus/generalinfo/"
}

extension APIiProBonus {
    
    static func request(_ path: APIPath, jsonObject: AccessTokenRequest)  -> AnyPublisher<AccessToken, Error> {
        guard let components = URLComponents(url: baseUrl.appendingPathComponent(path.rawValue), resolvingAgainstBaseURL: true)
        else { fatalError("Couldn't create URLComponents") }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("891cf53c-01fc-4d74-a14c-592668b7a03c", forHTTPHeaderField: "AccessKey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            request.httpBody = try encoder.encode(jsonObject)
        } catch {
            print(error)
        }
        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    static func request(_ path: APIPath, parameters: String)  -> AnyPublisher<GeneralInfo, Error> {
        guard let components = URLComponents(url: baseUrl.appendingPathComponent(path.rawValue).appendingPathComponent(parameters), resolvingAgainstBaseURL: true)
        else { fatalError("Couldn't create URLComponents") }
        var request = URLRequest(url: components.url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    public class func getClientInfo(ClientID:String, DeviceID:String, completion: @escaping (GeneralInfo) -> Void){
        cancellable = self.request(.client, jsonObject: AccessTokenRequest(ClientID: ClientID, DeviceID: DeviceID))
            .mapError({ (error) -> Error in
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                    guard $0.result.status == 0 else {
                       return
                    }
                    getInfoRequest(token: $0.accessToken!, completion: { info in
                        completion(info)
                    })
            })
    }
    
    static func getInfoRequest(token:String, completion: @escaping (GeneralInfo) -> Void){
        cancellable = self.request(.clientInfo, parameters:token)
            .mapError({ (error) -> Error in
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                    guard $0.resultOperation.status == 0 else {
                       return
                    }
                    completion($0)
            })
    }
}
