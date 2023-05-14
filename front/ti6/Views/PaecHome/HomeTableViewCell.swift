//
//  HomeTableViewCell.swift
//  ti6
//
//  Created by Larissa Kaweski Siqueira on 10/03/23.
//

import UIKit

public struct HomeTableViewCellEntity: Equatable {
    public let userName: String
    public let userImage: String
    public let backgroundColor: String
}

class HomeTableViewCell: UITableViewCell {

    static let identifier = "HomeTableViewCell"
    
    public lazy var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 0.4
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    
    private lazy var hStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.spacing = 12
        stack.axis = .horizontal
        return stack
    }()
    
    private lazy var labelTitle: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userImage: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addViewHierarchy()
        addConstraints()
    }
    
    private func addViewHierarchy() {
        addSubview(view)
        view.addSubview(hStackView)
    }
    
    private func addConstraints() {
        let viewConstraints = [
            view.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ]
        
        let stackConstraints = [
            hStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            hStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            hStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
        ]
        
        let imageConstraint = [
            userImage.heightAnchor.constraint(equalToConstant: 60),
            userImage.widthAnchor.constraint(equalToConstant: 60)
        ]
        
        NSLayoutConstraint.activate(viewConstraints)
        NSLayoutConstraint.activate(stackConstraints)
        NSLayoutConstraint.activate(imageConstraint)
    }
    
    public func updateView(_ entity: HomeTableViewCellEntity) {
        setImages(entity.userImage)
        setLabels(entity.userName)
        setBackgroundColor(entity.backgroundColor)
    }
    
    private func setImages(_ image: String) {
        userImage.image = UIImage(named: image)
        hStackView.addArrangedSubview(userImage)
    }
    
    private func setLabels(_ label: String) {
        labelTitle.text = label
        labelTitle.font = .systemFont(ofSize: 17, weight: .bold)
        labelTitle.textColor = UIColor.black
        hStackView.addArrangedSubview(labelTitle)
    }
    
    private func setBackgroundColor(_ color: String) {
        view.backgroundColor = UIColor(hexString: color)
        hStackView.backgroundColor = UIColor(hexString: color)
        labelTitle.backgroundColor = UIColor(hexString: color)
        userImage.backgroundColor = UIColor(hexString: color)
    }
    
}
            
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

