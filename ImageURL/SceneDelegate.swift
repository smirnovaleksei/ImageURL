//
//  SceneDelegate.swift
//  ImageURL
//
//  Created by Aleksei Smirnov on 08.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScence = scene as? UIWindowScene else { return }
        ImageURLCache.current.removeAllCachedResponses()
        window = UIWindow(windowScene: windowScence)
        window?.windowScene = windowScence
        let viewController = ViewController()
        viewController.imageURLs = buildImageURLs()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

    private func buildImageURLs() -> [String] {
        let arr = [
            "https://redstapler.co/wp-content/uploads/2019/05/3d-photo-from-image-800x500.jpg",
            "https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg",
            "https://image.shutterstock.com/image-photo/white-transparent-leaf-on-mirror-260nw-1029171697.jpg",
            "https://html5css.ru/css/img_lights.jpg",
            "https://interactive-examples.mdn.mozilla.net/media/examples/grapefruit-slice-332-332.jpg",
            "https://www.nasa.gov/sites/default/files/styles/image_card_4x3_ratio/public/thumbnails/image/denman20200325-nasa.jpg",
            "https://en.es-static.us/upl/2018/12/comet-wirtanen-Jack-Fusco-dec-2018-Anza-Borrego-desert-CA-e1544613895713.jpg",
            "https://cdn.eso.org/images/thumb300y/eso1907a.jpg",
            "https://www.gettyimages.pt/gi-resources/images/Homepage/Hero/PT/PT_hero_42_153645159.jpg",
            "https://html5css.ru/css/img_forest.jpg",
            "https://webdevetc.com/blog_images/how-to-add-a-gradient-overlay-to-a-background-image-using-just-css-and-html-pj2i500x333.jpg",
            "https://upload.wikimedia.org/wikipedia/commons/9/9a/Gull_portrait_ca_usa.jpg",
            "https://miac.swiss/gallery/full/126/slider3@2x.jpg",
            "https://miac.swiss/gallery/full/126/slider3@2x.jpg",
            "https://cdn.eso.org/images/large/eso1322a.jpg",

            // repeat

            "https://redstapler.co/wp-content/uploads/2019/05/3d-photo-from-image-800x500.jpg",
            "https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg",
            "https://image.shutterstock.com/image-photo/white-transparent-leaf-on-mirror-260nw-1029171697.jpg",
            "https://html5css.ru/css/img_lights.jpg",
            "https://interactive-examples.mdn.mozilla.net/media/examples/grapefruit-slice-332-332.jpg",
            "https://www.nasa.gov/sites/default/files/styles/image_card_4x3_ratio/public/thumbnails/image/denman20200325-nasa.jpg",
            "https://en.es-static.us/upl/2018/12/comet-wirtanen-Jack-Fusco-dec-2018-Anza-Borrego-desert-CA-e1544613895713.jpg",
            "https://cdn.eso.org/images/thumb300y/eso1907a.jpg",
            "https://www.gettyimages.pt/gi-resources/images/Homepage/Hero/PT/PT_hero_42_153645159.jpg",
            "https://html5css.ru/css/img_forest.jpg",
            "https://webdevetc.com/blog_images/how-to-add-a-gradient-overlay-to-a-background-image-using-just-css-and-html-pj2i500x333.jpg",
            "https://upload.wikimedia.org/wikipedia/commons/9/9a/Gull_portrait_ca_usa.jpg",
            "https://miac.swiss/gallery/full/126/slider3@2x.jpg",
            "https://miac.swiss/gallery/full/126/slider3@2x.jpg",
            "https://cdn.eso.org/images/large/eso1322a.jpg"
        ]

        var arr2 = [String]()

        for _ in (0...200) {
            let randomID = Int.random(in: 0 ..< 990)
            arr2.append("https://i.picsum.photos/id/\(randomID)/200/200.jpg")
        }

        return arr2 + arr
    }
}

