//
//  ListPresenter.swift
//  People
//
//  Created by Ufuk Canlı on 31.03.2023.
//

import Foundation

protocol ListPresenterInterface {
    func viewDidLoad()
    func didPullDown()
    func didTapRetry()
}

final class ListPresenter {
    private(set) var people: [Person] = []
    private(set) var nextPage: String? = nil
    
    weak var view: ListViewInterface?
    
    let navigationBarTitle = "People"
    
    var numberOfRowsInSection: Int {
        people.count
    }
    
    func getPerson(at indexPath: IndexPath) -> String {
        people[indexPath.row].fullName
    }
    
    private func fetchData() {
        view?.beginRefreshing()
        DataSource.fetch(next: nextPage) { [weak self] response, error in
            if let _ = error {
                self?.people = []
                self?.displayWarning()
                return
            }
            guard let response else {
                self?.displayWarning()
                return
            }
            self?.setData(response)
        }
    }
    
    private func displayWarning() {
        view?.endRefreshing()
        view?.reloadTableView()
    }
    
    private func setData(_ response: FetchResponse) {
        people = response.people
        nextPage = response.next
        view?.reloadTableView()
        view?.endRefreshing()
    }
}

extension ListPresenter: ListPresenterInterface {
    func viewDidLoad() {
        fetchData()
    }
    
    func didPullDown() {
        fetchData()
    }
    
    func didTapRetry() {
        fetchData()
    }
}
