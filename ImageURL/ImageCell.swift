//
//  ImageCell.swift
//  ImageURL
//
//  Created by Aleksei Smirnov on 09.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

struct ImageCellViewModel: ViewModelProtocol, XListViewModel {
    let url: String
}

final class ImageCell: XCollectionCell {

    // MARK: - Private Properties

    private let urlImageView = URLImageView()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        urlImageView.frame = frame
        addSubview(urlImageView)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Overridings

    override func layoutSubviews() {
        super.layoutSubviews()
        urlImageView.frame = bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        urlImageView.prepareForReuse()
    }

    override func configure(viewModel: XListViewModel, delegate: XListCellDelegate?) {
        guard let viewModel = viewModel as? ImageCellViewModel else { return }
        decorate(model: viewModel)
    }
}

extension ImageCell: Reusable { }

extension ImageCell: Decoratable {

    typealias ViewModel = ImageCellViewModel

    func decorate(model: ViewModel) {
        urlImageView.render(url: model.url)
    }
}
