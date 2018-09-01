//
//  CustomModuleRule.swift
//  IBLinterKit
//
//  Created by FukagawaSatoru on 2018/7/3.
//

import Foundation
import IBDecodable
import IBLinterKit
import Yams
import SourceKittenFramework

public struct CustomModuleRule: Rule {

    public struct Config: Codable {
        enum CodingKeys: String, CodingKey {
            case customModuleRule = "custom_module_rule"
        }
        let customModuleRule: [CustomModuleConfig]
    }

    public static let identifier: String = "custom_module"

    private var moduleClasses: [String:[String]] = [:]

    public init(context: Context) {

        guard let configPath = context.configPath,
            let configContent = try? String(contentsOf: configPath),
            let config = try? YAMLDecoder().decode(Config.self, from: configContent) else {
                self.init(config: .init(customModuleRule: []))
                return
        }
        self.init(config: config)
    }

    public init(config: Config) {
        for customModuleConfig in config.customModuleRule {
            print(customModuleConfig.included.first!)
            let paths = customModuleConfig.included.flatMap { glob(pattern: "\($0)/**/*.swift") }
            let excluded = customModuleConfig.excluded.flatMap { glob(pattern: "\($0)/**/*.swift") }
            let lintablePaths = paths.filter { !excluded.map { $0.absoluteString }.contains($0.absoluteString) }
            var classes: [String] = []
            for path in lintablePaths {
                let file = SourceKittenFramework.File(path: path.relativePath)
                let fileClasses: [String] = file?.structure.dictionary.substructure.compactMap { dictionary in
                    if let kind = dictionary.kind, SwiftDeclarationKind(rawValue: kind) == .class {
                        return dictionary.name
                    }
                    return nil
                    } ?? []
                classes += fileClasses
            }
            self.moduleClasses[customModuleConfig.module] = classes
        }
    }

    public func validate(xib: XibFile) -> [Violation] {
        guard let views = xib.document.views else { return [] }
        return views.flatMap { validate(for: $0.view, file: xib, fileNameWithoutExtension: xib.fileNameWithoutExtension) }
    }

    public func validate(storyboard: StoryboardFile) -> [Violation] {
        guard let scenes = storyboard.document.scenes else { return [] }
        let views = scenes.compactMap { $0.viewController?.viewController.rootView }
        return views.flatMap { validate(for: $0, file: storyboard, fileNameWithoutExtension: storyboard.fileNameWithoutExtension) }
    }

    private func validate<T: InterfaceBuilderFile>(for view: ViewProtocol, file: T, fileNameWithoutExtension: String) -> [Violation] {
        let violation: [Violation] = {
            guard let customClass = view.customClass else { return [] }
            for moduleName in moduleClasses.keys {
                if let classes = moduleClasses[moduleName] {
                    if classes.contains(customClass) {
                        if let customModule = view.customModule {
                            if moduleName == customModule {
                                return []
                            }
                        }
                        let message = "It does not match custom module rule in \(fileNameWithoutExtension). Custom module of \(customClass) is \(moduleName)"
                        return [Violation(pathString: file.pathString, message: message, level: .error)]
                    }
                }
            }
            return []
        }()
        return violation + (view.subviews?.flatMap { validate(for: $0.view, file: file, fileNameWithoutExtension: fileNameWithoutExtension) } ?? [])
    }

}

private extension XibFile {
    var fileExtension: String {
        return URL.init(fileURLWithPath: pathString).pathExtension
    }
    var fileNameWithoutExtension: String {
        return fileName.replacingOccurrences(of: ".\(fileExtension)", with: "")
    }
}

private extension StoryboardFile {
    var fileExtension: String {
        return URL.init(fileURLWithPath: pathString).pathExtension
    }
    var fileNameWithoutExtension: String {
        return fileName.replacingOccurrences(of: ".\(fileExtension)", with: "")
    }
}
