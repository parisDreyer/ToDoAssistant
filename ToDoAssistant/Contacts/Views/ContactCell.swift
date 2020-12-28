//
//  ContactCell.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 12/24/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation
import UIKit

protocol ContactCellOutput: AnyObject {
    func didTapContact(email: String)
    func didTapContact(phoneNumber: String)
}

final class ContactCell: UICollectionViewCell {
    public static let reuseIdentifier = "CONTACT CELL"
    typealias ViewModel = Contact

    let name = UILabel()
    let number = UILabel()
    let email = UILabel()
    let image = UIImageView(frame: .zero)
    weak var delegate: ContactCellOutput?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func applyViewModel(_ viewModel: ViewModel) {
        name.text = viewModel.name
        number.text = viewModel.phoneNumber
        email.text = viewModel.emailAddress
        image.image = viewModel.image
    }
}

// MARK: - Private

private extension ContactCell {

    func commonInit() {
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        isUserInteractionEnabled = true
        backgroundColor = .white

        name.textAlignment = .left
        number.textAlignment = .left
        number.textColor = .blue
        email.textAlignment = .left
        email.textColor = .blue

        let numberTappedEvent = UITapGestureRecognizer(target: self, action: #selector(phoneNumberTapped))
        numberTappedEvent.cancelsTouchesInView = true
        number.addGestureRecognizer(numberTappedEvent)
        number.isUserInteractionEnabled = true

        let emailTappedEvent = UITapGestureRecognizer(target: self, action: #selector(emailTapped))
        emailTappedEvent.cancelsTouchesInView = true
        email.addGestureRecognizer(emailTappedEvent)
        email.isUserInteractionEnabled = true

        [name, number, email, image].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: topAnchor),
            name.leadingAnchor.constraint(equalTo: leadingAnchor),
            name.trailingAnchor.constraint(equalTo: trailingAnchor),
            name.bottomAnchor.constraint(equalTo: number.topAnchor),

            number.topAnchor.constraint(equalTo: name.bottomAnchor),
            number.leadingAnchor.constraint(equalTo: leadingAnchor),
            number.trailingAnchor.constraint(equalTo: trailingAnchor),
            number.bottomAnchor.constraint(equalTo: email.topAnchor),

            email.topAnchor.constraint(equalTo: number.bottomAnchor),
            email.leadingAnchor.constraint(equalTo: leadingAnchor),
            email.trailingAnchor.constraint(equalTo: trailingAnchor),
            email.bottomAnchor.constraint(equalTo: image.topAnchor),

            image.bottomAnchor.constraint(equalTo: email.bottomAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.topAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc func phoneNumberTapped() {
        guard let text = number.text else { return }
        delegate?.didTapContact(phoneNumber: text)
    }

    @objc func emailTapped() {
        guard let text = email.text else { return }
        delegate?.didTapContact(email: text)
    }
}
