//
//  UploadPhoto.swift
//  ti6
//
//  Created by Larissa Kaweski Siqueira on 14/05/23.
//

import Foundation
import UIKit

class UploadPhotoViewController: UIViewController {
    
    private let presenter = UserPresenter()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.spacing = 12
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .systemGroupedBackground
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        image.layer.borderColor = UIColor.darkText.cgColor
        image.layer.borderWidth = 0.7
        return image
    }()
    
    private lazy var diagnosticoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var probabilidadeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Adionar Imagem", for: .normal)
        button.isEnabled = true
        button.addTarget(self, action: #selector(clickOpenPhotoGalery), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.backgroundColor = .black
        return button
    }()
    
    private lazy var enviarImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Enviar", for: .normal)
        button.isEnabled = true
        button.addTarget(self, action: #selector(clickEnviarPhoto), for: .touchUpInside)
        button.isHidden = true
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        return button
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
       let image = UIActivityIndicatorView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.style = .large
        image.hidesWhenStopped = true
        image.startAnimating()
        image.isHidden = true
        return image
    }()
    
    private lazy var fill: UIView = {
       let image = UIView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.setContentHuggingPriority(.defaultLow, for: .vertical)
        return image
    }()
    
    let pickerPhotoController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter.setViewDelegate(delegate: self)
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(contentView)
        contentView.addSubview(imageView)
        stackView.addArrangedSubview(diagnosticoLabel)
        stackView.addArrangedSubview(probabilidadeLabel)
        stackView.addArrangedSubview(addImageButton)
        stackView.addArrangedSubview(loader)
        stackView.addArrangedSubview(enviarImageButton)
        stackView.setCustomSpacing(4, after: diagnosticoLabel)
        stackView.setCustomSpacing(24, after: probabilidadeLabel)
        
        addConstraints()
    }
    
    func addConstraints() {
        
        let stackConstraints = [
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ]
        
        let imageConstraints = [
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.30),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(stackConstraints)
        NSLayoutConstraint.activate(imageConstraints)
        NSLayoutConstraint.activate([
            enviarImageButton.heightAnchor.constraint(equalToConstant: 44),
            addImageButton.heightAnchor.constraint(equalToConstant: 44),
            loader.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc
    private func clickOpenPhotoGalery() {
        DispatchQueue.main.async {
            self.pickerPhotoController.delegate = self
            self.present(self.pickerPhotoController, animated: true, completion: nil)
        }
    }
    
    @objc
    private func clickEnviarPhoto() {
        
        if let image = imageView.image {
            showLoading(true)
            if let base64String = convertImageToBase64(image: image) {
                presenter.getUsers(ImageResponse.self, from: "http://127.0.0.1:5000/predict", method: .post, body: ["imagem": base64String], completion: { [weak self] status in
                    DispatchQueue.main.async {
                        self?.showLoading(false)
                    }
                })
            } else {
                showLoading(true)
            }
        }
    }
    
    private func showLoading(_ show: Bool) {
        self.enviarImageButton.isHidden = show
        self.loader.isHidden = !show
    }
    
    func convertImageToBase64(image: UIImage) -> String? {
        let imageData = image.jpegData(compressionQuality: 1.0) // Converte a imagem para dados JPEG
        return imageData?.base64EncodedString() // Converte os dados para base64
    }
}

extension UploadPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickerImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            imageView.image = pickerImage
        }
        picker.dismiss(animated: true)
        enviarImageButton.isHidden = false
        print("image: \(String(describing: imageView.image))")
    }
}

extension UploadPhotoViewController: UserPresenterDelegate {
    func presentImage<T>(response: T) where T : Decodable {
        DispatchQueue.main.async { [unowned self] in
            if let entity = response as? ImageResponse {
                diagnosticoLabel.text = entity.diagnostico
                diagnosticoLabel.isHidden = false
                probabilidadeLabel.text = entity.probabilidade
                probabilidadeLabel.isHidden = false
            }
        }
    }
}
