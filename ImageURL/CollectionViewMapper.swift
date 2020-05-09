//
//  CollectionViewMapper.swift
//  ImageURL
//
//  Created by Aleksei Smirnov on 09.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

enum CollectionViewMapper {

    /// cell mapper для экрана акций в ленте
    static let items: XCellMapper = { (viewModelType: XListViewModel.Type) -> XListCell.Type in
        switch viewModelType {

        case is ImageCellViewModel.Type:
            return ImageCell.self

        default:
            preconditionFailure()
        }
    }
}
