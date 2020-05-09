//
//  Reusable.swift
//  ImageURL
//
//  Created by Aleksei Smirnov on 09.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

public protocol Reusable: class {
    static var reuseId: String { get }
}

public extension Reusable where Self: UICollectionViewCell {
    static var reuseId: String {
        return String(describing: self)
    }
}

public typealias ReusableCollectionViewCell = Reusable & UICollectionViewCell

public extension UICollectionView {
    func register(_ array: ReusableCollectionViewCell.Type...) {
        array.forEach { (type) in
            self.register(type.self, forCellWithReuseIdentifier: type.reuseId)
        }
    }
}

