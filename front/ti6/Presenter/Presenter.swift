//
//  Presenter.swift
//  ti6
//
//  Created by Larissa Kaweski Siqueira on 16/03/23.
//

import Foundation
import UIKit

protocol UserPresenterDelegate: AnyObject {
    func presentUser<T: Decodable>(users: [T])
    func presentImage<T: Decodable>(response: T)
}

extension UserPresenterDelegate {
    func presentUser<T: Decodable>(users: [T]) { }
    func presentImage<T: Decodable>(response: T) { }
}

typealias PresenterDelegate = UserPresenterDelegate & UIViewController

class UserPresenter {
    
    weak var delegate: UserPresenterDelegate?
    
    public func getUsers<T: Decodable>(_ type: T.Type, from urlString: String, method: HTTPMethod, body: [String: Any]? = nil, completion: ((Bool) -> Void)? = nil) {
        guard let url = URL(string: urlString) else {
            completion?(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body {
            do {
                if let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted) {
                    request.httpBody = jsonData
                }
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            
            let str = String(decoding: data, as: UTF8.self)
            
            
            do {
                if method == .get {
                    let users = try JSONDecoder().decode([T].self, from: data)
                    self?.delegate?.presentUser(users: users)
                } else {
                    let image = try JSONDecoder().decode(T.self, from: data)
                    self?.delegate?.presentImage(response: image)
                }
                completion?(true)
            }
            catch {
                print(error)
                completion?(false)
            }
        }
        task.resume()
    }
    
    public func setViewDelegate(delegate: PresenterDelegate) {
        self.delegate = delegate
    }
    
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public struct ImageResponse: Decodable {
    let diagnostico: String?
    let probabilidade: String?
    let mensagem: String?
}
