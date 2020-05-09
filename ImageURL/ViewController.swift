//
//  ViewController.swift
//  ImageURL
//
//  Created by Aleksei Smirnov on 08.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class ViewController: UICollectionViewController {

    // MARK: - Public Properties

    var imageURLs: [String] = []

    private var dataSource: XCollectionDataSource?

    // MARK: - Initializers

    init() { super.init(collectionViewLayout: ViewController.buildLayout()) }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override public func loadView() {
        super.loadView()

        if let collectionView = collectionView {
            collectionView.backgroundColor = .white
            collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            let items = imageURLs.map({ ImageCellViewModel(url: $0) })
            let itemsDataSource = XCommonDataSource(items: items,
                                                    viewModelTypes: [ImageCellViewModel.self],
                                                    mapper: CollectionViewMapper.items)
            dataSource = XCollectionDataSource(collectionView: collectionView, itemsDataSource: itemsDataSource)
            collectionView.dataSource = dataSource
        }
    }

    // MARK: - Private Methods

    private static func buildLayout() -> UICollectionViewFlowLayout {
        let inset: CGFloat = 8
        let rowCount = 3
        let itemSize = Int((UIScreen.main.bounds.width - inset * CGFloat(rowCount + 1)) / CGFloat(rowCount))

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        layout.minimumLineSpacing = inset
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        return layout
    }
}
