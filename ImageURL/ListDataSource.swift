//
//  ListDataSource.swift
//  ImageURL
//
//  Created by Aleksei Smirnov on 09.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

/// Маппер, возвращающий тип ячейки в зависимости от типа view model для этой ячейки
public typealias XCellMapper =
    (_ viewModelType: XListViewModel.Type) -> XListCell.Type

/// Вьюмодель элемента списка
public protocol XListViewModel { }

/// Протокол ячейки списка
public protocol XListCell: class {
    func configure(viewModel: XListViewModel, delegate: XListCellDelegate?)
}

/// Базовая ячейка для UICollectionView
open class XCollectionCell: UICollectionViewCell, XListCell {
    public func configure(viewModel: XListViewModel, delegate: XListCellDelegate?) {
    }
}

/// Протокол для действия, совершенного в списке (выбор элемента списка, нажата какая - то кнопка в ячейке и т.д.)
/// Делать объекты, реализующие этот протокол, по необходимости.
public protocol XListAction {}

public struct XListActionShow: XListAction {}

/// Набор базовых действий
public enum XBaseListActions {
    /// Выбор элемента списка
    static var showAction = XListActionShow()
}


/// Базовый делегат для ячеек
public protocol XListCellDelegate: class {
    func performAction(action: XListAction, viewModel: XListViewModel?)
}

/// View model для supplementary view
public protocol XSupplementaryViewModel { }

/// Протокол supplementary view
public protocol XCollectionSupplementaryView: class {
    func configure(with viewModel: XSupplementaryViewModel)
}

/// Базовый класс supplementary view для UICollectionView
open class XSupplementaryView: UICollectionReusableView, XCollectionSupplementaryView {
    public func configure(with viewModel: XSupplementaryViewModel) {
    }
}

/// Протокол для объекта, предоставляющего данные для списков
protocol XListDataSource {

    var viewModelTypes: [XListViewModel.Type] { get }
    var mapper: XCellMapper { get }

    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int

    func viewModel(in sectionIndex: Int, at itemIndex: Int) -> XListViewModel
    func viewModel(at indexPath: IndexPath) -> XListViewModel
}

/// Наиболее часто используемая реализация XListDataSource.
/// Инициализируется набором элементов, маппером ячеек и типами поддерживаемых вьюмоделей.
class XCommonDataSource: XListDataSource {

    var items: [XListViewModel]

    let mapper: XCellMapper
    let viewModelTypes: [XListViewModel.Type]

    init(
        items: [XListViewModel],
        viewModelTypes: [XListViewModel.Type],
        mapper: @escaping XCellMapper) {

        self.mapper = mapper
        self.viewModelTypes = viewModelTypes
        self.items = items
    }

    func numberOfSections() -> Int {
        return 1
    }

    func numberOfItems(in section: Int) -> Int {
        return items.count
    }

    func viewModel(in sectionIndex: Int, at itemIndex: Int) -> XListViewModel {
        return items[itemIndex]
    }

    func viewModel(at indexPath: IndexPath) -> XListViewModel {
        return viewModel(in: indexPath.section, at: indexPath.row)
    }
}

/// Объект, реализующий протокол UICollectionViewDataSource и предоставляющий данные для заполнения UICollectionView
/// Сами данные берутся из объекта itemsDataSource, реализующего протокол XListDataSource
/// Данные для supplementary views берутся из supplementaryViewsDataSource, реализующего протокол XSupplementaryViewsDataSource
class XCollectionDataSource: NSObject, UICollectionViewDataSource {

    var itemsDataSource: XListDataSource {
        didSet {
            registerCells()
        }
    }

    private weak var cellsDelegate: XListCellDelegate?
    private let collectionView: UICollectionView

    init(
        collectionView: UICollectionView,
        itemsDataSource: XListDataSource,
        cellsDelegate: XListCellDelegate? = nil) {

        self.collectionView = collectionView
        self.itemsDataSource = itemsDataSource
        self.cellsDelegate = cellsDelegate

        super.init()

        registerCells()
    }

    private func registerCells() {
        for viewModelType in itemsDataSource.viewModelTypes {
            collectionView.register(itemsDataSource.mapper(viewModelType))
        }
    }

    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return itemsDataSource.numberOfSections()
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsDataSource.numberOfItems(in: section)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cellViewModel = itemsDataSource.viewModel(in: indexPath.section, at: indexPath.row)

        guard let cellClass = itemsDataSource.mapper(type(of: cellViewModel)) as? XCollectionCell.Type else {
            assertionFailure("Некорректный тип ячейки, ячейка должна наследоваться от XCollectionCell")
            return UICollectionViewCell()
        }

        let cell = collectionView.dequeueReusableCell(cellClass, for: indexPath)

        cell.configure(viewModel: cellViewModel, delegate: cellsDelegate)
        cell.accessibilityIdentifier = "\(String(describing: cellClass)).\(indexPath.section).\(indexPath.row)"

        return cell
    }
}

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type,
                                                      for indexPath: IndexPath) -> T {
        let identifier = String(describing: type)
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }

    func register(_ classToRegister: AnyClass) {
        let identifier = String(describing: classToRegister)
        register(classToRegister, forCellWithReuseIdentifier: identifier)
    }
}

