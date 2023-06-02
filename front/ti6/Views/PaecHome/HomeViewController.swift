//
//  ViewController.swift
//  ti6
//
//  Created by Larissa Kaweski Siqueira on 10/03/23.
//

import UIKit
import Foundation

class HomeViewController: UIViewController {
    
    public let contentView: ViewProtocol?
    public var flowNavigationController: UINavigationController?
    private let presenter = UserPresenter()
    private var users = [UserEntity]()
    
    // MARK: - INITIALIZERS
    
    public init(contentView: ViewProtocol? = HomeView() ) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentSetup()
        presenter.setViewDelegate(delegate: self)
        presenter.getUsers(UserEntity.self, from: "http://127.0.0.1:5000/telaHome", method: .get)
    }

    private func contentSetup() {
        if let contentView = contentView {
            self.view = contentView.content
        }
        contentView?.delegate = self
    }

}

extension HomeViewController: ViewDelegate {
    func didTapCell(entity: UserEntity?) {
        let vc = DiagnosticViewController(entity: entity)
        if #available(iOS 15.0, *) {
            vc.sheetPresentationController?.detents = [.medium()]
        } else {
            // Fallback on earlier versions
        }
        present(vc, animated: true)
    }
}

extension ViewProtocol where Self: UIView {
    public var content: UIView { return self }
}

extension HomeViewController: UserPresenterDelegate {
    func presentImage<T>(response: T) where T : Decodable {
        
    }
    
    func presentUser<T>(users: [T]) where T : Decodable {
        if let getEntity = users as? [UserEntity] {
            self.users = getEntity
            contentView?.updateView(entity: getEntity)
        }
    }
}
