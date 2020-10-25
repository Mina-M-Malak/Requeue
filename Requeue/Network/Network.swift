//
//  Network.swift
//  TonesProject
//
//  Created by Mina Malak on 6/27/20.
//  Copyright © 2020 Mina Malak. All rights reserved.
//

import Foundation

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    case message(value: String)
    
    var localizedDescription: String {
        switch self {
        case .requestFailed:
            return "Request Failed"
        case .invalidData:
            return "Invalid Data"
        case .responseUnsuccessful:
            return "Response Unsuccessful"
        case .jsonParsingFailure:
            return "JSON Parsing Failure"
        case .jsonConversionFailure:
            return "JSON Conversion Failure"
        case .message(let value):
            return value
        }
    }
}

class Network{
    // Our singletone
    static let shared:Network = Network()
    private var timer:Timer?
    private var sessionTask:URLSessionDataTask?
    private init(){}
    
    private func initRequest(_ clientRequest:Tons)->URLRequest {
        var request:URLRequest = clientRequest.request
        
        request.httpMethod = clientRequest.method.rawValue
        request.httpBody = clientRequest.body
        request.addHeaders(clientRequest.headers)
        
        print("clientRequest.path==\(clientRequest.path)",Date())
        
        // cancel request
        if sessionTask != nil && clientRequest.Cancellable {
            if (sessionTask?.originalRequest?.url?.absoluteString.contains(clientRequest.path) ?? false) {
                print ("Canceled \(sessionTask?.originalRequest?.url?.absoluteString) with \(clientRequest.request.url?.absoluteString),clientRequest.path\(clientRequest.path) ")
                sessionTask?.cancel()
                sessionTask?.suspend()
            }
        }
        return request
    }
    
    private func JSONTask<T:Decodable>(with request: URLRequest, decodingModel: T.Type, completion: @escaping (APIResult<T, APIError>)-> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                print("RequestTimeOut)")
                return
            }
            print("request url:\(String(describing: request.url)) with status code \(httpResponse.statusCode)")
            switch httpResponse.statusCode {
            case 200...204,400...504:
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                var responseModel: T
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    guard JSONSerialization.isValidJSONObject(json) else {
                        completion(.failure(.invalidData))
                        return
                    }
                    responseModel = try JSONDecoder().decode(T.self, from: data)
                } catch let err {
                    print("request url:\(String(describing: request.url)) with serialization error \(err)")
                    
                    completion(.failure(.jsonConversionFailure))
                    return
                }
                /* Response is dictionary */
                switch httpResponse.statusCode {
                case 200...204:
                    completion(.success(responseModel))
                case 400...504:
                    completion(.failure(.message(value: "Error please try again later")))
                default:
                    completion(.failure(.responseUnsuccessful))
                }
            default:
                completion(.failure(.responseUnsuccessful))
            }
        }
        return task
    }
    
    
    
    func fetch<T: Decodable>( with clientRequest: Tons, model: T.Type,qos:DispatchQoS.QoSClass = .default, completion: ((APIResult<T, APIError>)->())?) {
        DispatchQueue.global(qos: .background).async {
            let request:URLRequest = self.initRequest(clientRequest)
            self.sessionTask = self.JSONTask(with: request, decodingModel: model.self) {[weak self] (result) in
                self?.timer?.invalidate()
                self?.timer = nil
                guard let self = self else { return }
                guard let sessionTask = self.sessionTask else { return }
                guard let response = self.handleResponse(sessionTask, result) else {
                    print("Error accured with the response")
                    return
                }
                
                DispatchQueue.main.async {
                    completion?(response)
                }
            }
            self.sessionTask?.resume()
        }
    }
    
    private func handleResponse<T: Decodable>(_ task:URLSessionTask, _ response: APIResult<T,APIError>)->APIResult<T,APIError>? {
        print("request== \(task.state.rawValue)")
        return response
    }
}
