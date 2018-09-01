import XCTest
import IBLinterKit
import IBDecodable
@testable import CustomModule

final class CustomModuleTests: XCTestCase {

    func testCustomModule() throws {
        let rule = CustomModuleRule(
            config: .init(
                customModuleRule: [
                    CustomModuleConfig(
                        module: "TestCustomModule",
                        included: ["Tests/Resources/TestCustomModule"],
                        excluded: ["Tests/Resources/TestCustomModule/CustomModuleExcluded"]
                    )
                ]
            )
        )
        let ngUrl = self.url(forResource: "CustomModuleNGTest", withExtension: "xib")
        let ngViolations = try rule.validate(xib: XibFile(url: ngUrl))
        XCTAssertEqual(ngViolations.count, 1)
        let okUrl = self.url(forResource: "CustomModuleOKTest", withExtension: "xib")
        let okViolations = try rule.validate(xib: XibFile(url: okUrl))
        XCTAssertEqual(okViolations.count, 0)
    }

    static var allTests = [
        ("testCustomModule", testCustomModule),
    ]
}

extension XCTestCase {

    func context(from config: Config) -> Context {
        return Context(
            config: config, workDirectory: FileManager.default.currentDirectoryPath,
            configPath: nil,
            externalRules: []
        )
    }

    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    func url(forResource resource: String, withExtension ext: String) -> URL {
        if let url = bundle.url(forResource: resource, withExtension: ext) {
            return url
        }
        return URL(fileURLWithPath: "Tests/Resources/\(resource).\(ext)")
    }
}
