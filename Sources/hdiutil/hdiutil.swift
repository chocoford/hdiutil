import Foundation
import AppKit
import os

/// Apple Docs: https://ss64.com/osx/hdiutil.html
final public class hdiutilClass {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "hdiutil")
    
    public private(set) var log = false
    var isSandbox: Bool {
        false
    }
    
    fileprivate init() {}
    
    public func configure(options: ConfigOption...) {
        for option in options {
            switch option {
                case .log(let enabled):
                    self.log = enabled
            }
        }
    }
    
    /// display minimal usage information for each verb.  hdiutil verb help will provide basic usage information for that verb.
    @discardableResult
    public func help() async throws -> String {
        try await self.run(verb: .help)
    }
    
    /// attach a disk image as a device.  attach will return information about an already-attached image as if it had attached it. mount is a poorly-named synonym for attach.
    ///
    /// Beware that an image freshly created and attached is treated as a new removable device.  See hdid(8) and the EXAMPLES section below for more details about how owners are ignored on filesystems on such devices.
    ///
    /// The output of attach has been stable since macOS 10.0 (though it was called hdid(8) then) and is intended to be program-readable.  It consists of the /dev node, a tab, a content hint (if applicable), another tab, and a mount point (if any filesystems were mounted).  Because content hints are derived from the partition data, GUID Partition Table types can leak through.  Common GUIDs such as "48465300-0000-11AA-AA11-0030654" are mapped to their human-readable counterparts(here "Apple_HFS").
    @discardableResult
    public func attach(image: String, options: [AttachImageOption]) async throws -> AttachOutput {
        let outputString = try await self.run(verb: .attach(image, options))
        
        guard let output = AttachOutput(outputString) else {
            throw hdiutilError.attachError(.invalidOutput)
        }
        return output
    }
    
    /// detach a disk image and terminate any associated process. dev\_name is a partial /dev node path (e.g. "disk1").  As of OS X 10.4, dev\_name can also be a mountpoint.  If Disk Arbitration is running, detach will use it to unmount any filesystems and detach the image.  If not, detach will attempt to unmount any filesystems and detach the image directly (using the `eject` ioctl).  If Disk Arbitration is not running, it can be necessary to unmount the filesystems with umount(8) before detaching the image.  eject is a synonym for detach.
    ///
    /// Options:
    /// -force   ignore open files on mounted volumes, etc.
    @discardableResult
    public func detach(deviceName: String, force: Bool = false) async throws -> String {
        try await self.run(verb: .detach(deviceName, force))
    }
    
    
    /// compute the checksum of a "read-only" or "compressed" image and verify it against the value stored in the image.
    ///
    /// Read/write images don't contain checksums and thus can't be verified.  
    /// verify accepts the common options -encryption, -stdinpass, -srcimagekey, -puppetstrings, and -plist.
    @discardableResult
    public func verify(image: String, options: [Any]) throws -> String {
        fatalError("Not implemented error")
    }
    
    
    /// create a new image of the given size or from the provided data.
    ///
    /// If image already exists, -ov must be specified or create will fail.  To make a cross-platform CD or DVD, use `makehybrid` instead.
    ///
    /// The size specified is the size of the image to be created. Filesystem and partition layout overhead (80 sectors for the default GPTSPUD layout on Intel machines) might not be available for the filesystem and user data in the image.
    @discardableResult
    public func create(image: String, to desPath: String? = nil, options: [CreateImageOption]) async throws -> CreateOutput {
        let imagePath: String
        if let desPath = desPath {
            if desPath.hasSuffix("/") {
                imagePath = desPath + image
            } else {
                imagePath = desPath + "/" + image
            }
        } else {
            imagePath = image
        }
        let outputString = try await self.run(verb: .create(imagePath, options), path: desPath)
        
        guard let output = CreateOutput(outputString) else {
            throw hdiutilError.createError(.invalidOutput)
        }
        
        return output
    }
    
    /// Convert image to type format and write the result to outfile.
    ///
    /// As with create, the correct filename extension will be added only if it isn't part of the provided name.  Format is one of:
    ///
    ///     UDRW - UDIF read/write image
    ///     UDRO - UDIF read-only image
    ///     UDCO - UDIF ADC-compressed image
    ///     UDZO - UDIF zlib-compressed image
    ///     UDBZ - UDIF bzip2-compressed image (macOS 10.4+ only)
    ///     UFBI - UDIF entire image with MD5 checksum
    ///     UDRo - UDIF read-only (obsolete format)
    ///     UDCo - UDIF compressed (obsolete format)
    ///     UDTO - DVD/CD-R master for export
    ///     UDxx - UDIF stub image
    ///     UDSP - SPARSE (grows with content)
    ///     UDSB - SPARSEBUNDLE (grows with content; bundle-backed)
    ///     RdWr - NDIF read/write image (deprecated)
    ///     Rdxx - NDIF read-only image (Disk Copy 6.3.3 format)
    ///     ROCo - NDIF compressed image (deprecated)
    ///     Rken - NDIF compressed (obsolete format)
    ///     DC42 - Disk Copy 4.2 image
    ///
    /// In addition to the compression offered by some formats, the UDIF and NDIF read-only formats skip unused space in HFS, UFS, and MS-DOS (FAT) filesystems.  For UDZO, -imagekey zlib-level=value allows the zlib compression level to be specified ala gzip(1).  The default compression level is 1 (fastest).
    @discardableResult
    public func convert(
        image: String,
        format: ConvertImageOption.Format,
        outFile: String,
        options: [ConvertImageOption]
    ) async throws -> String {
        try await run(verb: .convert(image, format, outFile, options: options))
    }
    
    @available(*, unavailable)
    @discardableResult
    public static func burn(image: String, options: [Any]) throws -> String {
        fatalError("Not implemented error")
    }
    
    @available(*, unavailable)
    @discardableResult
    public static func makeHybrid(image: String, options: [Any]) throws -> String {
        fatalError("Not implemented error")
    }
    
    @available(*, unavailable)
    @discardableResult
    public static func compact(image: String, options: [Any]) throws -> String {
        fatalError("Not implemented error")
    }
    
    /// Get information about attached images.
    @discardableResult
    public func info(options: InfoOptions = []) async throws -> String {
        try await self.run(verb: .info(options))
    }
    
    @available(*, unavailable)
    @discardableResult
    public static func checksum(image: String, options: [Any]) throws -> String {
        fatalError("Not implemented error")
    }
    
    @available(*, unavailable)
    @discardableResult
    public static func chpass(image: String, options: [Any]) throws -> String {
        fatalError("Not implemented error")
    }
    
    @available(*, unavailable)
    @discardableResult
    public static func eraseKeys(image: String, options: [Any]) throws -> String {
        fatalError("Not implemented error")
    }
    
    @available(*, unavailable)
    @discardableResult
    public static func unflatten(image: String, options: [Any]) throws -> String {
        fatalError("Not implemented error")
    }
    
    @available(*, unavailable)
    @discardableResult
    public static func flatten(image: String, options: [Any]) throws -> String {
        fatalError("Not implemented error")
    }
    
    @available(*, unavailable)
    @discardableResult
    public static func fsid(image: String, options: [Any]) throws -> String {
        fatalError("Not implemented error")
    }
    
    @available(*, unavailable)
    @discardableResult
    public static func mountVol(image: String, options: [Any]) throws -> String {
        fatalError("Not implemented error")
    }
    
    @available(*, unavailable)
    @discardableResult
    public static func unmount(image: String, options: [Any]) throws -> String {
        fatalError("Not implemented error")
    }
    
    @available(*, unavailable)
    @discardableResult
    public static func imageInfo(image: String, options: [Any]) throws -> String {
        fatalError("Not implemented error")
    }
    
    @available(*, unavailable)
    @discardableResult
    public static func isencrypted(image: String, options: [Any]) throws -> String {
        fatalError("Not implemented error")
    }
    
    @available(*, unavailable)
    @discardableResult
    public static func plugins(image: String, options: [Any]) throws -> String {
        fatalError("Not implemented error")
    }
    
    /// Enable or disable download post-processing (IDME).
    ///
    /// yes is the default.
    /// When enabled, a browser (or Disk Copy 10.2.3+) will "unpack" the contents:
    /// the image's visible contents will be copied into the directory containing the image and the image will be put into the trash with IDME disabled.
    @discardableResult
    public func internetEnable(
        image: String,
        enablity: InternetEnableOption.Enability,
        options: InternetEnableOptions
    ) throws -> String {
        fatalError("Not implemented error")
    }
    
    
    /// Resize a disk image or the containers within it.  
    ///
    /// For an image containing a trailing Apple\_HFS partition, the default is to resize the image container, the partition, and the filesystem within it by aligning the end of the hosted structures with the end of the image.  hdiutil resize cannot resize filesystems other than HFS+ and its variants.
    ///
    /// resize can shrink an image so that its HFS/HFS+ partition can be converted to CD-R/DVD-R format and still be burned. hdiutil resize will not reclaim gaps because it does not move data.  diskutil(8)'s resize can move filesystem data which can help hdiutil resize create a minimally-sized image.  -fsargs can also be used to minimize filesystem gaps inside an image.
    ///
    /// resize is limited by the disk image container format (e.g. UDSP vs. UDSB), any partition scheme, the hosted filesystem, and the filesystem hosting the image.  In the case of HFS+ inside of GPT inside of a UDRW on HFS+ with adequate free space, the limit is approximately 2^63 bytes.  Older images created with an APM partition scheme are limited by it to 2TB. Before macOS 10.4, resize was limited by how the filesystem was created (see hdiutil create with `stretch`).
    ///
    /// hdiutil burn does not burn Apple\_Free partitions at the end of the devices, so an image with a resized filesystem can be burned to create a CD-R/DVD-R master that contains only the actual data in the hosted filesystem (assuming minimal data fragmentation).
    @discardableResult
    public func resize(image: String, options: [ResizeImageOption]) async throws -> String {
        try await run(verb: .resize(image, options))
    }
    
    @available(*, unavailable)
    @discardableResult
    public static func segment(image: String, options: [Any]) throws -> String {
        fatalError("Not implemented error")
    }
    
    @available(*, unavailable)
    @discardableResult
    public static func pmap(image: String, options: [Any]) throws -> String {
        fatalError("Not implemented error")
    }
    
    
    /// Embed resources (e.g. a software license agreement) in a disk image.
    @discardableResult
    public func udifrez(image: String, options: UDIFrezOptions) async throws -> String {
        try await run(verb: .udifrez(image, options))
    }
    
    @available(*, unavailable)
    @discardableResult
    public static func udifderez(image: String, options: [Any]) async throws -> String {
        fatalError("Not implemented error")
    }
}

public let hdiutil = hdiutilClass()

internal extension hdiutilClass {
    enum Verb {
        case help
        case attach(String, [AttachImageOption])
        case detach(String, _ force: Bool)
//        case verify
        case create(String, [CreateImageOption])
        case convert(_ image: String, _ format: ConvertImageOption.Format, _ outFile: String, options: [ConvertImageOption])
//        case burn
        case info(InfoOptions)
//        case internetEnable(String, Any)
        case resize(String, [ResizeImageOption])
        
        case udifrez(String, UDIFrezOptions)
           
        var arguments: [String] {
            switch self {
                case .help:
                    return ["help"]
                case .attach(let imageName, let attachImageOptions):
                    return [
                        "attach",
                        imageName
                    ] + attachImageOptions.arguments
                case .detach(let devName, let force):
                    return [
                        "detach",
                        devName,
                    ] + (force ? ["-force"] : [])
                case .create(let imageName, let createImageOptions):
                    return [
                        "create",
                        imageName
                    ] + createImageOptions.arguments
                case .convert(let imageName, let format, let outFile, let convertImageOptions):
                    return [
                        "convert",
                        "-format", format.rawValue,
                        "-o", outFile
                    ] + convertImageOptions.arguments + [
                        imageName
                    ]
                case .info(let options):
                    return [
                        "info"
                    ] + options.arguments
                case .resize(let imageName, let resizeImageOptions):
                    return [
                        "resize"
                    ] + resizeImageOptions.arguments + [
                        imageName
                    ]
                case .udifrez(let imageName, let options):
                    return [
                        "udifrez"
                    ] + options.arguments + [
                        imageName
                    ]
            }
        }
        
        var stringValue: String {
            switch self {
                case .help:
                    "help"
                case .attach(let imageName, let attachImageOptions):
                    "attach \"\(imageName)\" \(attachImageOptions.stringValue)"
                case .detach(let devName, let force):
                    "detach \"\(devName)\" \(force ? "-force" : "")"
                case .create(let imageName, let createImageOptions):
                     "create \"\(imageName)\" \(createImageOptions.stringValue)"
                case .convert(let imageName, let format, let outFile, let convertImageOptions):
                    "convert -format \(format.rawValue) -o \"\(outFile)\" \(convertImageOptions.stringValue) \"\(imageName)\""
                case .info(let options):
                    "info \(options.stringValue)"
                case .resize(let imageName, let resizeImageOptions):
                    "resize \(resizeImageOptions.stringValue) \"\(imageName)\""
                case .udifrez(let imageName, let options):
                    "udifrez \(options.stringValue) \"\(imageName)\""
            }
        }

    }
    
    
    func run(verb: Verb, path: String? = nil) async throws -> String {
        let output: String
        if isSandbox {
            output = try await runHDIUtilViaAppleScript(verb.stringValue, path: path)
        } else {
            output = try await runHDIUtil(verb.arguments)
        }
        return output

    }
    
    
    @discardableResult
    private func runHDIUtil(_ arguments: [String]) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let task = Process()
                let pipe = Pipe()
                let errPipe = Pipe()
                
                task.standardInput = nil
                task.standardOutput = pipe
                task.standardError = errPipe
                task.arguments = arguments
                task.executableURL = URL(string: "file:///usr/bin/hdiutil")
                
//                if let resourceURL = Bundle.main.url(forResource: "hdiutil", withExtension: nil) {
//                    self.logger.info("hdiutil found in Resources.")
//                    task.executableURL = resourceURL
//                } else if let auxiliaryURL = Bundle.main.url(forAuxiliaryExecutable: "hdiutil") {
//                    self.logger.info("hdiutil found in Copies.")
//                    task.executableURL = auxiliaryURL
//                } else {
//                    self.logger.info("hdiutil not found in bundle, use /usr/bin/hdiutil instead.")
//                    task.executableURL = URL(string: "file:///usr/bin/hdiutil")
//                }
                
                if self.log {
                    self.logger.debug("executableURL: \(task.executableURL?.absoluteString ?? "nil", privacy: .public)")
                    self.logger.debug("run: \(arguments, privacy: .public)")
                }
                
                try task.run()
                task.waitUntilExit()
                
                let output: String
                
                struct TaskError: LocalizedError {
                    var errorDescription: String?
                }
                if #available(macOS 10.15.4, *), let data = try errPipe.fileHandleForReading.readToEnd() {
                    guard data.isEmpty else {
                        throw hdiutilError.processError(String(data: data, encoding: .utf8))
                    }
                } else {
                    let data = errPipe.fileHandleForReading.readDataToEndOfFile()
                    guard data.isEmpty else {
                        throw hdiutilError.processError(String(data: data, encoding: .utf8))
                    }
                }
                
                if #available(macOS 10.15.4, *), let data = try pipe.fileHandleForReading.readToEnd() {
                    output = String(data: data, encoding: .utf8) ?? ""
                } else {
                    let data = pipe.fileHandleForReading.readDataToEndOfFile()
                    output = String(data: data, encoding: .utf8)!
                }
                if self.log {
                    self.logger.debug("output: \(output, privacy: .public)")
                }
                continuation.resume(returning: output)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    
    @discardableResult
    private func runHDIUtilViaAppleScript(_ command: String, path: String? = nil) async throws -> String {
        let shellCommands: [String] = (path != nil ? ["cd \\\"\(path!)\\\""] : [])
        +
        [
            "/usr/bin/hdiutil \(command.replacingOccurrences(of: "\"", with: "\\\""))"
        ]
        
        let scriptText = "do shell script \"\(shellCommands.joined(separator: " && "))\""
        
        if self.log {
            self.logger.debug("run apple script: \(scriptText, privacy: .public)")
        }
        
        var error: NSDictionary?
        guard let script = NSAppleScript(source: scriptText) else { 
            throw hdiutilError.invalidAppleScriptText
        }
        
        let outputString: String = try await withCheckedThrowingContinuation { continuation in
            let eventDes = script.executeAndReturnError(&error)
            if let error = error {
                continuation.resume(throwing: hdiutilError.unexpected(error))
                return
            }
            continuation.resume(returning: eventDes.stringValue ?? "")
        }
        
        if self.log {
            self.logger.debug("output: \(outputString, privacy: .public)")
        }
        
        return outputString
    }
}


public extension hdiutilClass {
    enum ConfigOption {
        case log(_ enabled: Bool)
    }
}
