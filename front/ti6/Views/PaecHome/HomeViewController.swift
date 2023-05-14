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
        presenter.getUsers()
    }

    private func contentSetup() {
        if let contentView = contentView {
            self.view = contentView.content
        }
        contentView?.delegate = self
    }

}

extension HomeViewController: ViewDelegate {
    func didTapCell() {
        let vc = DiagnosticViewController()
//        navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true)
    }
}

extension ViewProtocol where Self: UIView {
    public var content: UIView { return self }
}

extension HomeViewController: UserPresenterDelegate {
    func presentUser(users: [UserEntity]) {
        self.users = users
        contentView?.updateView(entity: users)
    }
}
