//
//  ContactsViewController.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 12/24/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation
import UIKit

protocol ContactsViewOutput: AnyObject {
    func getContacts()
    func sendEmail(to address: String)
    func makeCall(to number: String)
}

protocol ContactsViewInput: AnyObject {
    func showContactsList(contacts: [Contact])
}

final class ContactsViewController: UIViewController {
    private enum Constants {
        static let spacing: CGFloat = 8
    }
    struct ViewModel {
        let contacts: [Contact]
    }
    private(set) var viewModel: ViewModel = .init(contacts: []) {
        didSet {
            updateView()
        }
    }

    let presenter: ContactsViewOutput
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = .init(width: 50, height: 50)
        layout.minimumInteritemSpacing = Constants.spacing

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.register(ContactCell.self, forCellWithReuseIdentifier: ContactCell.reuseIdentifier)
        return view
    }()

    var cellWidth: CGFloat {
        return collectionView.frame.size.width - 2 * Constants.spacing
    }

    init(presenter: ContactsViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: Bundle.main)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // load in dispatch queue because otherwise view loads before presenter is set
        DispatchQueue.main.async {
            self.presenter.getContacts()
        }
    }
}

// MARK: - Private

private extension ContactsViewController {
    func updateView() {
        collectionView.reloadData()
    }

    func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }

    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func didTapCell(at indexPath: IndexPath) {
//        let section = viewModel.contacts[indexPath.section]
    }
}

// MARK: - ContactsViewInput

extension ContactsViewController: ContactsViewInput {
    func showContactsList(contacts: [Contact]) {
        viewModel = .init(contacts: contacts)
    }
}

extension ContactsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapCell(at: indexPath)
    }
}

// MARK: - UICollectionViewDataSource

extension ContactsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.contacts.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCell.reuseIdentifier, for: indexPath) as! ContactCell
        cell.delegate = self
        cell.isUserInteractionEnabled = true
        cell.applyViewModel(viewModel.contacts[indexPath.section])
        return cell
    }
}

extension ContactsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: cellWidth, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: Constants.spacing, left: Constants.spacing, bottom: Constants.spacing, right: Constants.spacing)
    }
}

// MARK: - ContactCellOutput

extension ContactsViewController: ContactCellOutput {

    func didTapContact(email: String) {
        presenter.sendEmail(to: email)
    }

    func didTapContact(phoneNumber: String) {
        presenter.makeCall(to: phoneNumber)
    }

}
