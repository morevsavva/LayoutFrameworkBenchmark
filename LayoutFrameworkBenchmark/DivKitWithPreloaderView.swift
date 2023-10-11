//
//  DivKitPerfView.swift
//  LayoutFrameworkBenchmark
//
//  Created by Savva Morev on 10.10.2023.
//

import Foundation
import UIKit
import DivKit
import NetworkingPublic

class DivKitWithPreloaderView: UIView, DataBinder {
  typealias DataType = FeedItemData

  private let cardId = {
    defer { cardIdIndex = (cardIdIndex + 1) % 100 }
    return DivCardID(rawValue: cardIdIndex.description)
  }()
  lazy var divView: DivView = {
    let divView = DivView(divKitComponents: divkitComponents, divViewPreloader: divPreloader)
    divView.showCardId(cardId)
    addSubview(divView)
    return divView
  }()

  func setData(_ data: FeedItemData) {

  }

  override func layoutSubviews() {
    super.layoutSubviews()
    divView.frame = bounds
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return sizes[Int(cardId.rawValue)!]!
  }
}

private func makeImageHolderFactory() -> ImageHolderFactory {
  ImageHolderFactory(
    make: { url, _ in
      let hostDict = [
        "small": UIImage(named: "50x50")!,
        "big": UIImage(named: "350x200")!
      ]
      return url?.components?.host.flatMap { hostDict[$0] } ?? UIImage()
    }
  )
}

private var cardIdIndex = 0

private let divkitComponents = DivKitComponents(imageHolderFactory: makeImageHolderFactory())

private let sizes = (0...99).map {
  divPreloader.expectedSize(for: .init(rawValue: $0.description))?.sizeFor(parentViewSize: .init(width: 5000, height: 5000))
}

private let divPreloader: DivViewPreloader = {
  let preloader = DivViewPreloader(divKitComponents: divkitComponents)
  divDatas.enumerated().forEach {
    preloader.setSource(.init(kind: .divData($0.element), cardId: .init(rawValue: $0.offset.description)))
  }
  return preloader
}()


private let divDatas: [DivData] = (0...99).map {
  return try! divkitComponents.parseDivDataWithTemplates(jsonArray, cardId: DivCardID(rawValue: $0.description)).unwrap()
}

private let jsonArray = try! JSONSerialization.jsonObject(with: json.utf8Data!) as! [String : Any]

private let json = """
{
    "card": {
        "log_id": "div2_sample_card",
        "states": [
            {
                "state_id": 0,
                "div": {
                    "type": "container",
                    "width": {
                        "type": "wrap_content"
                    },
                    "height": {
                        "type": "wrap_content"
                    },
                    "orientation": "vertical",
                    "items": [
                        {
                            "type": "text",
                            "text": "action text"
                        },
                        {
                            "type": "container",
                            "orientation": "horizontal",
                            "items": [
                                {
                                    "type": "image",
                                    "width": {
                                        "type": "fixed",
                                        "value": 50
                                    },
                                    "height": {
                                        "type": "fixed",
                                        "value": 50
                                    },
                                    "image_url": "https://small"
                                },
                                {
                                    "type": "container",
                                    "orientation": "vertical",
                                    "items": [
                                        {
                                            "type": "text",
                                            "text": "poster name"
                                        },
                                        {
                                            "type": "text",
                                            "text": "poster long long long long name"
                                        },
                                        {
                                            "type": "text",
                                            "text": "poster timestamp"
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            "type": "text",
                            "text": "comment"
                        },
                        {
                                    "type": "image",
                                    "width": {
                                        "type": "fixed",
                                        "value": 250
                                    },
                                    "height": {
                                        "type": "fixed",
                                        "value": 250
                                    },
                                    "image_url": "https://big"
                        },
                        {
                            "type": "text",
                            "text": "content title"
                        },
                        {
                            "type": "text",
                            "text": "content domain"
                        },
                        {
                            "type": "container",
                            "orientation": "horizontal",
                            "content_alignment_horizontal": "space-between",
                            "items": [
                                {
                            "type": "text",
                            "width": {
                                "type": "wrap_content"
                            },
                            "text": "like"
                        },
                        {
                            "type": "text",
                            "width": {
                                "type": "wrap_content"
                            },
                            "text": "comment"
                        },
                        {
                            "type": "text",
                            "width": {
                                "type": "wrap_content"
                            },
                            "text": "share"
                        }
                            ]
                        },
                        {
                            "type": "container",
                            "orientation": "horizontal",
                            "items": [
                                {
                                    "type": "image",
                                    "width": {
                                        "type": "fixed",
                                        "value": 50
                                    },
                                    "height": {
                                        "type": "fixed",
                                        "value": 50
                                    },
                                    "image_url": "https://small"
                                },
                                {
                                    "type": "text",
                                    "text": "poster name",
                                    "alignment_vertical": "center"
                                }
                            ]
                        }
                    ]
                }
            }
        ]
    }
}

"""