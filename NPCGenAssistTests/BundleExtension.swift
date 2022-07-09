//
//  BundleExtension.swift
//  NPCGenAssistTests
//
//  Created by Michael Craun on 7/9/22.
//

import Foundation

extension Bundle {
    public func url(testFile: String, withExtension: String) -> URL? {
        let testsDirectory = URL(fileURLWithPath: #file).deletingLastPathComponent()
        let targetFile = "/\(testFile).\(withExtension)"

        let allFiles = FileManager.default.enumerator(atPath: testsDirectory.path)!
        while let file = allFiles.nextObject() as? String {
            if file.hasSuffix(targetFile) {
                return testsDirectory.appendingPathComponent(file)
            }
        }

        return nil
    }
}
