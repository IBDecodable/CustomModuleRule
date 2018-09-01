import XCTest

import CustomModuleTests

var tests = [XCTestCaseEntry]()
tests += CustomModuleTests.allTests()
XCTMain(tests)