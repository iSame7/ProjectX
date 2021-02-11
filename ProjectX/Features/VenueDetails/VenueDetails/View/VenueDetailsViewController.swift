//
//  VenueDetailsViewController.swift
//  VenueDetails
//
//  Created Sameh Mabrouk on 04/02/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Utils
import DesignSystem
import RxCocoa
import FoursquareCore

class Book: NSObject {
    
    let name: String
    let details: String
    
    init(name: String, details: String) {
        self.name = name
        self.details = details
    }
}

class VenueDetailsViewController: ViewController<VenueDetailsViewModel> {
    
    // MARK: - Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(RatingTableViewCell.self, forCellReuseIdentifier: ratingCellReuseIdentifier)
        tableView.register(AddressTableViewCell.self, forCellReuseIdentifier: addressCellReuseIdentifier)
        tableView.register(MapTableViewCell.self, forCellReuseIdentifier: mapCellReuseIdentifier)
        tableView.register(PhotoGalleryTableViewCell.self, forCellReuseIdentifier: PhotoGalleryTableViewCell.reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var stretchyHeader: VenueDetailsTableStretchyHeader!
    
    private let ratingCellReuseIdentifier = "RatingTableViewCellIdentifier"
    private let addressCellReuseIdentifier = "AddressTableViewCelldentifier"
    private let mapCellReuseIdentifier = "MapTableViewCelldentifier"

    lazy var backButton: UIButton = {
        let button: UIButton = ButtonFactory().build()
        button.setBackgroundImage(IconFactory(icon: .back).build(), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    var backButtonTapped: ControlEvent<Void> {
        return backButton.rx.tap
    }
    
    private let viewData = ["New York", "London", "Cairo", "Amsterdam"]
    let bookList = [
          Book(name: "Count of Monte Cristo", details: "The Count of Monte Cristo (French: Le Comte de Monte-Cristo) is an adventure novel by French author Alexandre Dumas (père) completed in 1844. It is one of the author's most popular works, along with The Three Musketeers. Like many of his novels, it is expanded from plot outlines suggested by his collaborating ghostwriter Auguste Maquet. The story takes place in France, Italy, and islands in the Mediterranean during the historical events of 1815–1839: the era of the Bourbon Restoration through the reign of Louis-Philippe of France."),
          Book(name: "Harry Potter and the Philosopher's Stone", details: "Harry Potter and the Philosopher's Stone is the first novel in the Harry Potter series and J. K. Rowling's debut novel, first published in 1997 by Bloomsbury. It was published in the United States as Harry Potter and the Sorcerer's Stone by Scholastic Corporation in 1998. The plot follows Harry Potter, a young wizard who discovers his magical heritage as he makes close friends and a few enemies in his first year at the Hogwarts School of Witchcraft and Wizardry."),
          Book(name: "The Monstrumologist", details: "The Monstrumologist (2009) is a young adult horror novel by Rick Yancey. It received the 2010 Michael L. Printz Honor Award for excellence in young adult literature."),
          Book(name: "Nineteen Eighty-Four", details: "Nineteen Eighty-Four, often published as 1984, is a dystopian novel by English author George Orwell published in 1949. The novel is set in Airstrip One (formerly known as Great Britain), a province of the superstate Oceania in a world of perpetual war, omnipresent government surveillance and public manipulation, dictated by a political system euphemistically named English Socialism (or Ingsoc in the government's invented language, Newspeak) under the control of a privileged elite of the Inner Party, that persecutes individualism and independent thinking as thoughtcrime.")
      ]
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.inputs.viewState.onNext(.loaded)
        setupUI()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - setupUI
    
    override func setupUI() {
        setupSubviews()
        setupConstraints()
        
        view.backgroundColor = .white
    }
    
    override func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupSubviews() {
        view.addSubview(tableView)
        stretchyHeader = VenueDetailsTableStretchyHeader(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width), viewData: viewModel.buildVenueTableHeaderViewData())
        tableView.tableHeaderView = stretchyHeader
        
        view.addSubview(backButton)
    }
    
    override func setupObservers() {
        viewModel.outputs.showVenueDetailsHeader.subscribe { [weak self] event in
            if let viewData = event.element {
                self?.stretchyHeader.setup(with: viewData)
            }
            self?.tableView.reloadData()
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.outputs.showError.subscribe { [weak self] error in
            // show error
        }.disposed(by: viewModel.disposeBag)
        
        backButtonTapped
            .bind(to: viewModel.inputs.backButtonTapped)
            .disposed(by: viewModel.disposeBag)
    }
    
    func presentMapActionSheet(location: Location) {
        let optionMenu = UIAlertController(title: "Directions", message: "Which app do you want to use?", preferredStyle: .actionSheet)
        
        optionMenu.addAction(UIAlertAction(title: "Use Apple Maps", style: .default) { [weak self] _ in
            self?.viewModel.inputs.showMap.onNext((type: .apple, location: location))
        })
        
        optionMenu.addAction(UIAlertAction(title: "Use Google Maps", style: .default) { [weak self] _ in
            self?.viewModel.inputs.showMap.onNext((type: .google, location: location))
        })
        
        optionMenu.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "presentmaps.cancel"), style: .cancel))
        
        present(optionMenu, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension VenueDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ratingCellReuseIdentifier, for: indexPath) as! RatingTableViewCell
            if let viewData = viewModel.buildRatingTableViewCellViewData() {
                cell.setup(viewData: viewData)
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: addressCellReuseIdentifier, for: indexPath) as! AddressTableViewCell
            if let viewData = viewModel.buildAddressTableViewCellViewData() {
                cell.setup(with: viewData)
            }
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: mapCellReuseIdentifier, for: indexPath) as! MapTableViewCell
            return cell
        }  else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoGalleryTableViewCell.reuseIdentifier) as! PhotoGalleryTableViewCell
            if let viewData = viewModel?.buildPhotoGalleryTableViewCellViewData() {
                cell.setup(with: viewData, imageSelectionHandler: { [weak self] (galleryPreview) in
                    self?.present(galleryPreview, animated: true, completion: nil)
                })
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            cell.backgroundColor = .white
            return cell
        }

    }
}

// MARK: - UITableViewDataSource

extension VenueDetailsViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.tableHeaderView as? VenueDetailsTableStretchyHeader else { return }
        
        header.scrollViewDidScroll(scrollView: tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            if let location = viewModel?.venueLocation() {
                presentMapActionSheet(location: location)
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension VenueDetailsViewController {
    
    struct ViewData {
        let venue: Venue
    }
}
