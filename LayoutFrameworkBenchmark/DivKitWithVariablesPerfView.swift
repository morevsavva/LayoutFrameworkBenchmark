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

class DivKitWithVariablesPerfView: UIView, DataBinder {
  typealias DataType = FeedItemData

  let variablesStorage = DivVariablesStorage()
  let cardId = DivCardID(rawValue: UUID().uuidString)

  lazy var divView: DivView = {
    let divkitComponents = DivKitComponents(imageHolderFactory: makeImageHolderFactory(), variablesStorage: variablesStorage)
    let divView = DivView(divKitComponents: divkitComponents)
    divView.setSource(.init(kind: .json(jsonArray), cardId: cardId))
    divView.frame.size = divView.intrinsicContentSize
    addSubview(divView)
    return divView
  }()

  func setData(_ data: FeedItemData) {
    variablesStorage.set(cardId: cardId, variables: [
      .init(rawValue: "action_text"): .string(data.actionText),
      .init(rawValue: "poster_name"): .string(data.actorComment),
      .init(rawValue: "poster_long_name"): .string(data.contentDomain),
      .init(rawValue: "poster_timestamp"): .string(data.contentTitle),
      .init(rawValue: "poster_comment"): .string(data.posterComment),
      .init(rawValue: "poster_domain"): .string(data.posterHeadline),
      .init(rawValue: "actor_comment"): .string(data.posterName),
    ])
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    divView.frame = bounds
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return divView.intrinsicContentSize
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

private let jsonArray = try! JSONSerialization.jsonObject(with: json.utf8Data!) as! [String : Any]

private let json = """
{
    "card": {
        "variables": [
            {
                "name": "action_text",
                "type": "string",
                "value": "1"
            },
             {
                "name": "poster_name",
                "type": "string",
                "value": "1"
            },
            {
                "name": "poster_long_name",
                "type": "string",
                "value": "1"
            },
            {
                "name": "poster_timestamp",
                "type": "string",
                "value": "1"
            },
            {
                "name": "poster_comment",
                "type": "string",
                "value": "1"
            },
            {
                "name": "poster_domain",
                "type": "string",
                "value": "1"
            },
            {
                "name": "actor_comment",
                "type": "string",
                "value": "1"
            }
        ],
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
                            "text": "action text @{action_text}"
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
                                            "text": "poster name @{poster_name}"
                                        },
                                        {
                                            "type": "text",
                                            "text": "poster long long long long name @{poster_long_name}"
                                        },
                                        {
                                            "type": "text",
                                            "text": "poster timestamp @{poster_timestamp}"
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            "type": "text",
                            "text": "comment @{poster_timestamp}"
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
                            "text": "content title @{poster_comment}"
                        },
                        {
                            "type": "text",
                            "text": "content domain @{poster_domain}"
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
                                    "text": "poster name @{actor_comment}",
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
