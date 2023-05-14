//
//  DiagnosticViewController.swift
//  ti6
//
//  Created by Larissa Kaweski Siqueira on 13/03/23.
//

import UIKit

public protocol DiagnosticViewControllerProtocol: AnyObject {
    func updateViewController(_ entity: DiagnosticViewEntity)
}

public protocol DiagnosticViewDelegate: AnyObject { }

class DiagnosticViewController: UIViewController {

    public let contentView: DiagnosticViewProtocol?
    
    // MARK: - INITIALIZERS
    
    public init(contentView: DiagnosticViewProtocol? = DiagnosticView() ) {
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
    }

    private func contentSetup() {
        if let contentView = contentView {
            self.view = contentView.content
        }
        contentView?.delegate = self
    }

}

extension DiagnosticViewController: DiagnosticViewDelegate { }

extension DiagnosticViewController: DiagnosticViewControllerProtocol {
    func updateViewController(_ entity: DiagnosticViewEntity) {
        contentView?.updateView(entity)
    }
}

extension DiagnosticViewProtocol where Self: UIView {
    public var content: UIView { return self }
}
