//
//  ExcalidrawTextElement.swift
//  ExcalidrawZ
//
//  Created by Dove Zachary on 2023/8/6.
//

import Foundation
enum FontFamily: Int, Codable {
    case virgil = 1
    case helvetica = 2
    case cascadia = 3
}

enum TextAlign: String, Codable {
    case left, right, center
}

enum VerticalAlign: String, Codable {
    case top, bottom, middle
}

protocol ExcalidrawTextElementBase: ExcalidrawElementBase {
    var fontSize: Double { get }
    var fontFamily: Int { get }
    var text: String { get }
    var textAlign: TextAlign { get }
    var verticalAlign: VerticalAlign { get }
    var containerId: ExcalidrawGenericElement.ID? { get }
    var originalText: String? { get }
    /**
     * Unitless line height (aligned to W3C). To get line height in px, multiply
     * with font size (using `getLineHeightInPx` helper).
     */
    var lineHeight: Double? { get }
}
//extension ExcalidrawTextElementBase {
//    var type: ExcalidrawElementType { .text }
//}

struct ExcalidrawTextElement: ExcalidrawTextElementBase {
    var type: ExcalidrawElementType
    
    var id: String
    var x: Double
    var y: Double
    var strokeColor: String
    var backgroundColor: String
    var fillStyle: ExcalidrawFillStyle
    var strokeWidth: Double
    var strokeStyle: ExcalidrawStrokeStyle
    var roundness: ExcalidrawRoundness?
    var roughness: Double
    var opacity: Double
    var width: Double
    var height: Double
    var angle: Double
    var seed: Int
    var version: Int
    var versionNonce: Int
    var isDeleted: Bool
    var groupIds: [String]
    var frameId: String?
    var boundElements: [ExcalidrawBoundElement]?
    var updated: Double? // not available in v1
    var link: String?
    var locked: Bool? // not available in v1
    var customData: [String : AnyCodable]?
    
    var fontSize: Double
    var fontFamily: Int
    var text: String
    var textAlign: TextAlign
    var verticalAlign: VerticalAlign
    var containerId: ExcalidrawGenericElement.ID?
    var originalText: String?
    var lineHeight: Double?
}
