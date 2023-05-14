//
//  DiagnosticView.swift
//  ti6
//
//  Created by Larissa Kaweski Siqueira on 14/03/23.
//

import Foundation
import UIKit

public protocol DiagnosticViewProtocol: AnyObject {
    var content: UIView { get }
    var delegate: DiagnosticViewDelegate? { get set }
    
    func updateView(_ entity: DiagnosticViewEntity)
}

class DiagnosticView: UIView {
    
    private lazy var scrollView: UIScrollView = {
       let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = true
        return scroll
    }()

    private lazy var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PAEC"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.spacing = 12
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Leanne Graham"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "84"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var sexLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mulher"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var diagnosticLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Diagnóstico: Taquicardia ventricular"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .blue
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var diagnosticImage: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        image.image = UIImage(named: "eletro")
        return image
    }()
    
    // MARK: - INITIALIZERS
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addViewHierarchy()
        addConstraints()
    }
    
    private func addViewHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(view)
        view.addSubview(title)
        view.addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(ageLabel)
        stackView.addArrangedSubview(sexLabel)
        stackView.addArrangedSubview(diagnosticLabel)
        stackView.addArrangedSubview(diagnosticImage)
    }
    
    private func addConstraints() {
        
        let scrollConstraints = [
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        let viewConstraints = [
            view.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor),
            view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.bottomAnchor),
            view.widthAnchor.constraint(equalTo: widthAnchor)
        ]
        
        let titleConstraints = [
            title.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            title.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -24)
        ]
        
        let stackConstraints = [
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ]
        
        NSLayoutConstraint.activate(scrollConstraints)
        NSLayoutConstraint.activate(viewConstraints)
        NSLayoutConstraint.activate(titleConstraints)
        NSLayoutConstraint.activate(stackConstraints)
    }
    
    public func updateViewEntity(_ entity: DiagnosticViewEntity) {
        nameLabel.text = entity.patientName
        ageLabel.text = entity.patientAge
        sexLabel.text = entity.patientSex
        diagnosticLabel.text = entity.patientDiagnostic
        diagnosticImage.image = entity.patientImage
    }

}

extension DiagnosticView: DiagnosticViewProtocol {
    var delegate: DiagnosticViewDelegate? {
        get {
            return nil
        }
        set {
            
        }
    }
    
    func updateView(_ entity: DiagnosticViewEntity) {
        updateViewEntity(entity)
    }
}
