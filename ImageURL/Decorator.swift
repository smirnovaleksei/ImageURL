//
//  Decoratable.swift
//  ImageURL
//
//  Created by Aleksei Smirnov on 09.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

public protocol ViewModelProtocol { }

public protocol Decoratable {

    associatedtype ViewModel: ViewModelProtocol

    func decorate(model: ViewModel)
}
