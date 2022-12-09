import Foundation
import SwiftUI

final class Post: Identifiable, Codable, Equatable, Hashable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id && lhs.userUID == rhs.userUID && rhs.description == lhs.description &&
        lhs.digital == rhs.digital && lhs.filmStock == rhs.filmStock && rhs.camera == lhs.camera &&
        lhs.lens == rhs.lens && lhs.shutterSpeed == rhs.shutterSpeed && rhs.aperture == lhs.aperture &&
        lhs.imageData == rhs.imageData && lhs.timeStamp == rhs.timeStamp
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var id = UUID()

    var userUID: String

    var description: String?
    var digital: Bool
    var filmStock: String?
    var camera: String?
    var lens: String?
    var shutterSpeed: ShutterSpeed?
    var aperture: Aperture?
    var iso: Int?

    var imageData: Data

    var timeStamp: Date

    init(
        userUID: String,
        description: String?,
        digital: Bool,
        filmStock: String?,
        camera: String?,
        lens: String?,
        shutterSpeed: ShutterSpeed?,
        aperture: Aperture?,
        iso: Int?,
        imageData: Data,
        timeStamp: Date
    ) {
        self.userUID = userUID
        self.description = description
        self.digital = digital
        self.filmStock = filmStock
        self.camera = camera
        self.lens = lens
        self.shutterSpeed = shutterSpeed
        self.aperture = aperture
        self.imageData = imageData
        self.timeStamp = timeStamp

        guard let iso = iso else { return }
        if iso > 0 && iso < 500000 {
            self.iso = iso
        }
    }

    static let mockVertical = Post(
        userUID: "FeJRlSOs2YMBGurnNyOju84T3pH2",
        // swiftlint:disable:next line_length
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        digital: false,
        filmStock: "Kodak Portra 400",
        camera: "Nikon F3",
        lens: "Nikkor 50mm f1.4",
        shutterSpeed: .twofiftieth,
        aperture: .twoPointEight,
        iso: 400,
        imageData: Asset.Images.verticalExample.image.pngData() ?? Data(),
        timeStamp: Date()
    )
    static let mockHorizontal = Post(
        userUID: "FeJRlSOs2YMBGurnNyOju84T3pH2",
        // swiftlint:disable:next line_length
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        digital: false,
        filmStock: "Kodak Portra 400",
        camera: "Nikon F3",
        lens: "Nikkor 50mm f1.4",
        shutterSpeed: .twofiftieth,
        aperture: .twoPointEight,
        iso: 400,
        imageData: Asset.Images.horizontalExample.image.pngData() ?? Data(),
        timeStamp: Date()
    )
}

enum ShutterSpeed: String, Codable, CaseIterable {
    case thirty, fifteen, ten, five, three, two, one,
    half, quarter, eighth, fifteenth, thirtieth, sixtieth,
    hundredtwentyfifth, twofiftieth, fivehundredth, thousandth,
    twothousandth, fourthousandth, eightthousandth, other

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func formatted() -> String {
        switch self {
        case .thirty:
            return "30s"
        case .fifteen:
            return "15s"
        case .ten:
            return "10s"
        case .five:
            return "5s"
        case .three:
            return "3s"
        case .two:
            return "2s"
        case .one:
            return "1s"
        case .half:
            return "1/2"
        case .quarter:
            return "1/4"
        case .eighth:
            return "1/8"
        case .fifteenth:
            return "1/15"
        case .thirtieth:
            return "1/30"
        case .sixtieth:
            return "1/60"
        case .hundredtwentyfifth:
            return "1/125"
        case .twofiftieth:
            return "1/250"
        case .fivehundredth:
            return "1/500"
        case .thousandth:
            return "1/1000"
        case .twothousandth:
            return "1/2000"
        case .fourthousandth:
            return "1/4000"
        case .eightthousandth:
            return "1/8000"
        case .other:
            return "Custom"
        }
    }
}

enum Aperture: String, Codable, CaseIterable {
    case pointNineFive, onePointZero, onePointOne, onePointTwo, onePointFour, onePointEight,
    two, twoPointTwo, twoPointFive, twoPointEight, three, threePointFive,
    four, fourPointFive, five, fivePointSix, sixPointThree, sevenPointOne,
    eight, nine, ten, eleven, thirteen, fourteen, sixteen, eighteen, twenty,
    twentyFive, twentyNine, thirtyTwo, thirtySix, other

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func formatted() -> String {
        switch self {
        case .pointNineFive:
            return "f0.95"
        case .onePointZero:
            return "f1.0"
        case .onePointOne:
            return "f1.1"
        case .onePointTwo:
            return "f1.2"
        case .onePointFour:
            return "f1.4"
        case .onePointEight:
            return "f1.8"
        case .two:
            return "f2.0"
        case .twoPointTwo:
            return "f2.2"
        case .twoPointFive:
            return "f2.5"
        case .twoPointEight:
            return "f2.8"
        case .three:
            return "f3.0"
        case .threePointFive:
            return "f3.5"
        case .four:
            return "f4.0"
        case .fourPointFive:
            return "f4.5"
        case .five:
            return "f5.0"
        case .fivePointSix:
            return "f5.6"
        case .sixPointThree:
            return "f6.3"
        case .sevenPointOne:
            return "f7.1"
        case .eight:
            return "f8.0"
        case .nine:
            return "f9.0"
        case .ten:
            return "f10.0"
        case .eleven:
            return "f11.0"
        case .thirteen:
            return "f13.0"
        case .fourteen:
            return "f14.0"
        case .sixteen:
            return "f16.0"
        case .eighteen:
            return "f18.0"
        case .twenty:
            return "f20.0"
        case .twentyFive:
            return "f25.0"
        case .twentyNine:
            return "f29.0"
        case .thirtyTwo:
            return "f32.0"
        case .thirtySix:
            return "f36.0"
        case .other:
            return "Custom"
        }
    }
}
