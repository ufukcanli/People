//
//  Person+Ext.swift
//  People
//
//  Created by Ufuk Canlı on 1.04.2023.
//

import Foundation

extension Array where Element: Person {
    func removeDuplicate(_ people: [Person]) -> [Person] {
        var uniquePeople = [Person]()
        for person in people {
            if !uniquePeople.contains(where: { $0.id == person.id }) {
                uniquePeople.append(person)
            }
        }
        return uniquePeople
    }
}

extension Person: Equatable {
    public static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == lhs.id
    }
}

extension Person: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
