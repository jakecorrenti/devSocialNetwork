//
//  NewPartnerSearchVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 6/1/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

protocol NewPostCapsuleCellSelectionDelegate {
	func handleCellSelected(indexPath: IndexPath, collectionView: UICollectionView)
}

class NewPartnerSearchVC: UIViewController {

	// -----------------------------------------
	// MARK: Properties
	// -----------------------------------------

	public var technologies = [String]()
	
	var sectionLabels = [
		"Title",
		"Description",
		"Technologies",
		"Contributors",
		"Tags"
	]

	// -----------------------------------------
    // MARK: Views
    // -----------------------------------------
	
	lazy var tableView: UITableView = {
		let view = UITableView(frame: .zero, style: .insetGrouped)
		view.backgroundColor = .systemBackground
		view.dataSource = self
		view.delegate = self
		view.estimatedRowHeight = 65
		view.keyboardDismissMode = .onDrag
		view.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 24))
		view.rowHeight = UITableView.automaticDimension
		view.register(TextFieldCell.self, forCellReuseIdentifier: Cells.textFieldCell)
		view.register(TextViewCell.self, forCellReuseIdentifier: Cells.textViewCell)
		view.register(EmbeddedCollectionViewCell.self, forCellReuseIdentifier: Cells.embeddedCollectionViewCell)
		return view
	}()
	
    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupUI()
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupNavBar() {
		view.backgroundColor = .systemBackground
    }
    
    private func setupUI() {
		view.addSubview(tableView)
		constrainTableView()
    }
	
	private func constrainTableView() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}

	private func addNewTechnologyCell() {
		let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! EmbeddedCollectionViewCell
		cell.data.append(technologies.last!)
		cell.collectionView.insertItems(at: [IndexPath(row: cell.data.count - 1, section: 0)])
		if cell.data.count > 1 {
			cell.collectionView.scrollToItem(at: IndexPath(row: cell.data.count - 1, section: 0), at: .bottom, animated: true)
		}
	}

	@objc
	func showTechnologyAlert() {
		Alert.showTextFieldAlert(on: self, title: "Add a technology you're using", onCancelPressed: { [weak self] in 
			guard let self = self else { return }
			self.dismiss(animated: true)
		}, onAddPressed: { [weak self] technology in
			guard technology != nil else { return }
			let technologyNoWhitespace = technology?.trimmingCharacters(in: .whitespacesAndNewlines)
			if technologyNoWhitespace != "" {
				guard let self = self else { return }
				self.technologies.append(technology ?? "")
				self.addNewTechnologyCell()
			}
		})
	}

	@objc
	func showContributorAlert() {
		print("CONTRIBUTORS")
	}

	@objc
	func showTagAlert() {
		print("TAGS")
	}
}

extension NewPartnerSearchVC: NewPostCapsuleCellSelectionDelegate {
	func handleCellSelected(indexPath: IndexPath, collectionView: UICollectionView) {
		Alert.showDeleteConfirmation(on: self, onDeleteSelected: { [weak self] in
			guard let self = self else { return }
			
		}) {
			let cell = collectionView.cellForItem(at: indexPath) as! CapsuleCell
			cell.backgroundColor = UIColor(named: ColorNames.mainColor)?.withAlphaComponent(0.2)
			cell.contentLabel.textColor = UIColor(named: ColorNames.mainColor)
		}
	}
}
