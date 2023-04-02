//
//  ListViewController.swift
//  People
//
//  Created by Ufuk Canlı on 31.03.2023.
//

import UIKit

protocol ListViewInterface: AnyObject {
    func reloadTableView()
    func beginRefreshing()
    func endRefreshing()
    func showEmptyState(with message: String)
    func hideEmptyState()
    func shouldStartLoading()
    func shouldStopLoading()
}

final class ListViewController: UIViewController {
    private let cellID = String(describing: ListViewController.self)
    
    private var emptyStateView: UIView = .emptyStateView
    private var emptyStateLabel: UILabel = .emptyStateLabel
    private var emptyStateButton: UIButton = .emptyStateButton
    private var loadingView: UIActivityIndicatorView = .loadingView
    private var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var refreshControl = UIRefreshControl()
    
    private let presenter: ListPresenter!
    
    init(presenter: ListPresenter! = ListPresenter()) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureEmptyStateView()
        
        presenter.view = self
        presenter.viewDidLoad()
        
        title = presenter.navigationBarTitle
    }
    
    @objc private func didPullDown() {
        presenter.didPullDown()
    }
    
    @objc private func didTapRetry() {
        presenter.didTapRetry()
    }
}

extension ListViewController: ListViewInterface {
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func beginRefreshing() {
        refreshControl.beginRefreshing()
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    func showEmptyState(with message: String) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.emptyStateView.isHidden = false
            self?.emptyStateLabel.text = message
            self?.emptyStateView.alpha = 1
        }
        tableView.isUserInteractionEnabled = false
    }
    
    func hideEmptyState() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.emptyStateView.isHidden = true
            self?.emptyStateView.alpha = 0
        }
        tableView.isUserInteractionEnabled = true
    }
    
    func shouldStartLoading() {
        loadingView.startAnimating()
    }
    
    func shouldStopLoading() {
        loadingView.stopAnimating()
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let person = presenter.getPerson(at: indexPath)
        cell.textLabel?.text = "\(person.fullName) \(person.id)"
        return cell
    }
}

private extension ListViewController {
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 52.0
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        refreshControl.addTarget(self, action: #selector(didPullDown), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func configureEmptyStateView() {
        view.addSubview(emptyStateView)
        
        emptyStateView.addSubview(loadingView)
        emptyStateView.addSubview(emptyStateLabel)
        emptyStateButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        emptyStateView.addSubview(emptyStateButton)
        
        NSLayoutConstraint.activate([
            emptyStateView.widthAnchor.constraint(equalToConstant: 250),
            emptyStateView.heightAnchor.constraint(equalToConstant: 150),
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loadingView.heightAnchor.constraint(equalToConstant: 50),
            loadingView.widthAnchor.constraint(equalToConstant: 50),
            loadingView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            loadingView.bottomAnchor.constraint(equalTo: emptyStateLabel.topAnchor, constant: 5),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -5),
            
            emptyStateButton.topAnchor.constraint(equalTo: emptyStateLabel.bottomAnchor, constant: 5),
            emptyStateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
