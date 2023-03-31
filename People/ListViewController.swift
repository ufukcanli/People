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
}

final class ListViewController: UIViewController {
    private let cellID = String(describing: ListViewController.self)
    private var tableView: UITableView!
    private var refreshControl: UIRefreshControl!
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
        configureRefreshControl()
        
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
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        presenter.numberOfRowsInSection
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = presenter.getPerson(at: indexPath)
        return cell
    }
}

private extension ListViewController {
    func configureTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 52.0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didPullDown), for: .valueChanged)
    }
}
