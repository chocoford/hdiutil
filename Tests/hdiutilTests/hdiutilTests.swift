import XCTest
@testable import hdiutil

final class hdiutilTests: XCTestCase {
    func testHelp() async throws {
        try await hdiutil.help()
    }
    
    func testCreate() async throws {
        hdiutil.log = true

        let targetPath = "/Users/chocoford/Downloads/test_hdituil/test.dmg"
        let output = try await hdiutil.create(
            image: "test.dmg",
            to: "/Users/chocoford/Downloads/test_hdituil/",
            options: [
                .srcFolder("/Users/chocoford/Downloads/test_hdituil/TrickleCapture_Test.app"),
                .volname("test"),
                .fs(.hfs),
                .fsargs("-c c=64,a=16,e=16"),
                .format(.udrw),
                .overwrite
            ]
        )
        XCTAssert(targetPath == output.dmgURL.path(percentEncoded: false))
    }
    

    
    func testAttachAndDetach() async throws {
        let output = try await attach()
        try await detach(deviceName: output.deviceNode)
    }
    
    func testConvert() async throws {
        try await compress()
    }
    
    
}


extension hdiutilTests {
    func attach() async throws -> hdiutilClass.AttachOutput {
        hdiutil.log = true
        let targetPath = "/Users/chocoford/Downloads/test_hdituil/test.dmg"
        let output = try await hdiutil.attach(image: targetPath, options: [
            .mountRandom("/tmp"),
            .readwrite,
            .verify(false),
            .autoOpen(false),
            .noBrowse
        ])
        return output
    }
    
    func detach(deviceName: String) async throws {
        hdiutil.log = true
        try await hdiutil.detach(deviceName: deviceName)
    }
    
    func compress() async throws {
        hdiutil.log = true
        try await hdiutil.convert(
            image: "/Users/chocoford/Downloads/test_hdituil/test.dmg",
            format: .udzo,
            outFile: "/Users/chocoford/Downloads/test_hdituil/Test2.dmg",
            options: [
                .overwrite,
                .imageKey("zlib-level", "9")
            ]
        )
    }
}
