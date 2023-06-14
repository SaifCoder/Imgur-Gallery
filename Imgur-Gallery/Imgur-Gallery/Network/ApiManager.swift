//
//  ApiManager.swift
//  Imgur-Gallery
//
//  Created by Saifali Terdale on 14/06/23.
//

import Foundation

public let ErrorDomain = "com.appx.error"
public let ErrorCodeAppNotActive = 666
public let ErrorCodeTimeout = 1001
public let ErrorCodeVersionTooOld = 1004
public let ErrorInvalidFunction = 1005
public let ErrorInvalidResponse = 1006

class ApiManager {
    private let baseUrl = "https://api.imgur.com/3/gallery/search/top/week/"

    private let decoder: JSONDecoder

    public init(_ decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    public enum HttpMethod : String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
    }

    private enum RestfulApiSubpath {
        case getTopImageForWeek


//    var getUrlSubpath : String {
//        get {
//            switch self {
//            case .getTopImageForWeek: return "3/gallery/search/top/week/"
//            }
//        }
//    }
    }

    func getTopImagesOfWeek(text:String, completion: @escaping ([ImageData]?)->Void ) {
        self.sendCloudReq(ImageDataModel.self, subpath: .getTopImageForWeek, text: text, method: .get, bodyArgs: nil, completion: { (response) in
            if let result = response?.data {
                    completion(result)
            } else {
                completion(nil)
            }
        }) { (error) in
            completion(nil)
        }
    }

    private func sendCloudReq<T: Decodable>(_ objectType: T.Type, subpath: RestfulApiSubpath, text: String,  method: HttpMethod, bodyArgs: [String: Any]?, completion: @escaping(T?) -> Void, error: @escaping(Error?) -> Void) {

        guard let url = URL(string: self.baseUrl)?.appending("q", value: text) else{return}

        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue

        // if we have a method, we probably have & http body
        if let bodyArgs = bodyArgs {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: bodyArgs) else { assert(false, "invalid json request"); return }
            req.httpBody = jsonData
        }

        let userAgent: String
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            userAgent = "iOS \(version) (\(build))"
        }
        else {
            userAgent = "iOS"
        }
        req.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Client-ID 07130ddf7d81427", forHTTPHeaderField: "Authorization")


            URLSession.shared.dataTask(with: req) { (data, res, err) in

                if err == nil, let status = res as? HTTPURLResponse {
                    print("API Response: \(status.statusCode)")

                            if let data = data {
                                do {
                                    let response = try self.decoder.decode(T.self, from: data)
                                    //Utils.shared.hideLoader()
                                        completion(response)
                                }
                                catch let error {
                                    print("error: \(error.localizedDescription) *** \(error)")
                                    completion(nil)
                                }
                            }


                }
                else if let err = err {
                    error(err)

                }
                else {
                    let err = NSError(domain: ErrorDomain, code: ErrorInvalidFunction, userInfo: nil)
                    error(err)
                }
            }.resume()

    }
}


extension URL {

    func appending(_ queryItem: String, value: String?) -> URL {

        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        return urlComponents.url!
    }
}
