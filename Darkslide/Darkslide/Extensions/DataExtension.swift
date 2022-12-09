import Foundation
import SwiftUI

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
            return nil
        }

        return prettyPrintedString
    }

    func getExifData() -> CFDictionary? {
        var exifData: CFDictionary?
        self.withUnsafeBytes {
            let bytes = $0.baseAddress?.assumingMemoryBound(to: UInt8.self)
            if let cfData = CFDataCreate(kCFAllocatorDefault, bytes, self.count),
               let source = CGImageSourceCreateWithData(cfData, nil) {
                exifData = CGImageSourceCopyPropertiesAtIndex(source, 0, nil)
            }
        }
        return exifData
    }
}
