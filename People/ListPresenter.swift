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
    func didTapRefresh()
}

final class ListPresenter {
    weak var view: ListViewInterface!
    
    private(set) var navigationBarTitle = "People"
    
    private var people: [Person] = []
    private var nextPage: String? = nil
    
    private var timer: Timer?
    private var counter = 0
    
    private(set) var isRefreshHidden = true
            
    var numberOfRowsInSection: Int {
        people.count
    }
    
    func getPerson(at indexPath: IndexPath) -> Person {
        people[indexPath.row]
    }
    
    private var emptyStateMessage: String {
        "🤪 Oops! Please check your \nnetwork connection\n or try again later."
    }
    
    private func fetchData() {
        DataSource.fetch(next: nextPage) { [weak self] response, error in
            if let error = error {
                self?.isRefreshHidden = false
                self?.retryRequest()
                dump(error)
                return
            }
            
            if let response, !response.people.isEmpty {
                self?.isRefreshHidden = true
                self?.populate(people: response.people)
                self?.nextPage = response.next
            } else {
                self?.isRefreshHidden = false
                self?.view.shouldStopLoading()
                let message = self?.emptyStateMessage
                self?.view.showEmptyState(with: message!)
                self?.view.endRefreshing()
            }
        }
    }
    
    private func populate(people newPeople: [Person]) {
        people.insert(contentsOf: newPeople, at: 0)
        people = people.removeDuplicate(people)
        isRefreshHidden = true
        view.hideEmptyState()
        view.reloadTableView()
        view.endRefreshing()
        timer?.invalidate()
        counter = 0
    }
    
    private func retryRequest() {
        isRefreshHidden = false
        counter += 1
        
        guard counter < 2 else {
            isRefreshHidden = true
            timer?.invalidate()
            view.endRefreshing()
            view.showEmptyState(with: emptyStateMessage)
            view.shouldStopLoading()
            counter = 0
            return
        }
        
        timer = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: false
        ) { [weak self] timer in
            self?.fetchData()
            self?.isRefreshHidden = false
        }
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
    
    func didTapRefresh() {
        view.shouldStartLoading()
        fetchData()
    }
}
