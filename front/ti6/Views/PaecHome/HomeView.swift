//
//  HomeView.swift
//  ti6
//
//  Created by Larissa Kaweski Siqueira on 10/03/23.
//

import Foundation
import UIKit

public protocol ViewProtocol: AnyObject {
    var content: UIView { get }
    var delegate: ViewDelegate? { get set }
    
    func updateView(entity: [UserEntity])
}

public protocol ViewDelegate: AnyObject {
    func didTapCell()
}

public class HomeView: UIView {
    
    weak public var delegate: ViewDelegate?
    private var userNameEntity: [String] = ["Larissa", "Gisele", "Ruan", "Natã", "Laura", "Bruna", "Laura", "Bruna"]
    private var userImageEntity: [String] = ["user1", "user2", "user3", "user4", "user5", "user6",
                                             "user5", "user6", "user5", "user6"]
    private var colorsPreference: [String] = ["#edfce3", "#fbfce3", "#fce3e4", "#edfce3", "#fbfce3",
                                              "#fce3e4", "#edfce3", "#edfce3", "#edfce3", "#edfce3"]
    private var users = [UserEntity]()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
       let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = true
        return scroll
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PAEC"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        return tableView
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
        scrollView.addSubview(contentView)
        contentView.addSubview(title)
        contentView.addSubview(tableView)
    }
    
    private func addConstraints() {
        
        let scrollConstraints = [
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        let contentViewConstraints = [
            contentView.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor)
        ]
        
        let titleConstraints = [
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            title.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -12)
        ]

        let tableViewConstraints = [
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(scrollConstraints)
        NSLayoutConstraint.activate(contentViewConstraints)
        NSLayoutConstraint.activate(titleConstraints)
        NSLayoutConstraint.activate(tableViewConstraints)
    }
    
    public func updateViewEntity(entity: [UserEntity]) {
        self.users = entity
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension HomeView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell
        let colorsPreferenceSorted = colorsPreference.sorted(by: >)
        let entity = HomeTableViewCellEntity(userName: users[indexPath.row].name,
                                             userImage: userImageEntity[indexPath.row],
                                             backgroundColor: colorsPreferenceSorted[indexPath.row])
        cell?.updateView(entity)
        return cell ?? UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didTapCell()
        print("tap here")
    }
}

extension HomeView: ViewProtocol {
    public func updateView(entity: [UserEntity]) {
        updateViewEntity(entity: entity)
    }
}
