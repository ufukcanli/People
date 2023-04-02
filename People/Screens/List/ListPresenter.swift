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
    weak var view: ListViewInterface!
    
    private(set) var navigationBarTitle = "People"
    
    private var people: [Person] = []
    private var nextPage: String? = nil
    
    private var requestCounter = 0
                
    var numberOfRowsInSection: Int {
        people.count
    }
    
    func getPerson(at indexPath: IndexPath) -> Person {
        people[indexPath.row]
    }
    
    private enum Message: String {
        case serverError = "Something went wrong.\n Please try again later."
        case emptyResponse = "Nothing to see here.\n Please try again now."
    }
    
    private func fetchData() {
        DataSource.fetch(next: nextPage) { [weak self] response, error in
            if let error = error {
                self?.retryRequest()
                dump(error)
                return
            }
            
            if let response, !response.people.isEmpty {
                self?.populate(people: response.people)
                self?.nextPage = response.next
            } else {
                self?.view.shouldStopLoading()
                self?.view.showEmptyState(with: Message.emptyResponse.rawValue)
                self?.view.endRefreshing()
            }
        }
    }
    
    private func populate(people newPeople: [Person]) {
        people.insert(contentsOf: newPeople, at: 0)
        people = people.removeDuplicate(people)
        view.hideEmptyState()
        view.reloadTableView()
        view.endRefreshing()
        requestCounter = 0
    }
    
    private func retryRequest() {
        requestCounter += 1
        
        guard requestCounter < 2 else {
            view.endRefreshing()
            view.showEmptyState(with: Message.serverError.rawValue)
            view.shouldStopLoading()
            requestCounter = 0
            return
        }
        
        fetchData()
    }
}

extension ListPresenter: ListPresenterInterface {
    func viewDidLoad() {
        view.beginRefreshing()
        fetchData()
    }
    
    func didPullDown() {
        view.beginRefreshing()
        fetchData()
    }
    
    func didTapRetry() {
        view.shouldStartLoading()
        fetchData()
    }
}
