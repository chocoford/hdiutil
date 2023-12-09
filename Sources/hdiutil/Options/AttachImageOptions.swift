//
//  AttachImageOptions.swift
//
//
//  Created by Dove Zachary on 2023/11/3.
//

import Foundation
extension hdiutilClass {
    public enum AttachImageOption: HDIUtilOptions {
        // MARK: - Device options
        
        /// force the resulting device to be read-only
        case readonly
        
        /// attempt to override the DiskImages framework's decision to attach a particular image read-only.
        ///
        /// For example, `readwrite` can be used to modify the HFS filesystem on a HFS/ISO hybrid CD image.
        case readwrite
        
        /// `True` if attaching the image with a helper process, otherwise `False`.
        ///
        /// Only `UDRW`, `UDRO`, `UDZO`, and `UDSP` images are supported in-kernel.  Encryption and HTTP-backed images are also supported.
        /// The Default is `False`.
        case kernel(_ enabled: Bool)
        
        /// prevent this image from being detached.
        ///
        /// Only root can use this option.
        case notremovable
        
        // MARK: - Mount options
        
        /// indicate whether filesystems in the image should be mounted or not.
        /// Pass `nil` is equal to `-nomount`.
        ///
        /// The default is required (attach will fail if no filesystems mount).
        case mount(_ option: MontOption?)
        
        /// Mount volumes on subdirectories of path instead of under /Volumes.
        ///
        /// path must exist.  Full mount point paths must be less than MNAMELEN characters (increased from 90 to 1024 in macOS 10.6).
        case mountRoot(_ path: String)
        
        /// like `mountRoot`, but mount point directory names are randomized with mkdtemp(3).
        case mountRandom(_ path: String)
        
        /// assuming only one volume, mount it at path instead of in /Volumes.
        ///
        /// See fstab(5) for ways a system administrator can make particular volumes automatically mount in particular filesystem locations by editing the file /etc/fstab.
        case mountPoint(_ path: String)
        
        /// render any volumes invisible in applications such as the macOS Finder.
        case noBrowse
        
        /// specify that owners on any filesystems be honored or not.
        case owners(_ enable: Bool)
        

        // MARK: -

        /// Specify whether bad checksums should be ignored.  
        ///
        /// The default is to cancel when a bad checksum is detected.
        case ignoreBadChecksums(_ enabled: Bool)
        
        /// Do [not] perform IDME actions on IDME images.  
        ///
        /// IDME actions are not performed by default.
        case idme(_ enabled: Bool)
        
        /// Do [not] reveal (in the Finder) the results of IDME processing.
        case idmeReveal(_ enabled: Bool)
        
        /// Do [not] put IDME images in the trash after processing.
        ///
        /// Preferences key: skip-idme-trash
        case idmeTrash(_ enabled: Bool)
        
        // MARK: - Processing options (defaults per framework preferences)
        
        /// Do [not] verify the image.
        ///
        /// By default, hdiutil attach attempts to intelligently verify images that contain checksums before attaching them.
        /// If hdiutil can write to an image it has verified, attach will store an attribute with the image so that it will not be verified again unless its timestamp changes.
        /// To maintain backwards compatibility, hdid(8) does not attempt to verify images before attaching them.
        /// Preferences keys: skip-verify, skip-verify-remote, skip-verify-locked, skip-previously-verified
        case verify(_ enabled: Bool)
        
        /// Do [not] auto-open volumes (in the Finder) after attaching an image.
        ///
        /// By default, double-clicking a read-only disk image causes the resulting volume to be opened in the Finder.
        /// hdiutil defaults to -noautoopen.
        case autoOpen(_ enabled: Bool)
        
        /// Do [not] auto-open read-only volumes.
        ///
        /// Preferences key: auto-open-ro-root
        case autoOpenReadonly(_ enabled: Bool)
        
        /// Do [not] auto-open read/write volumes.
        ///
        /// Preferences key: auto-open-rw-root
        case autoOpenReadwrite(_ enabled: Bool)
        
        /// Do [not] force automatic file system checking before mounting a disk image.
        ///
        /// By default, only quarantined images (e.g. downloaded from the Internet) that have not previously passed fsck are checked.\
        /// Preferences key: auto-fsck
        case autoFileSystemChecking(_ enabled: Bool)
        
        // MARK: - Common options
        
        /// Specify a particular type of encryption or, if not specified, the default encryption algorithm.
        ///
        /// The default algorithm is the AES cipher with a 128-bit key.
        case encryption(CommonOption.CryptoMethod)
        /// read a null-terminated passphrase from standard input.
        ///
        /// If the standard input is a tty, the passphrase will be read with readpassphrase(3).
        /// `stdinpass` replaces `passphrase` though the latter is still supported for compatibility.
        /// Beware that the password will contain any newlines before the NULL.
        case stdinPass
        
        case agentPass
        
        /// Specify a keychain containing the secret corresponding to the certificate specified with `certificate` when the image was created.
        case recover(_ keychainFile: String)
        
        case imageKey(_ key: String, _ value: String)

        /// specify a key/value pair to be attached to the device in the IOKit registry.
        case driveKey(_ key: String, _ value: String)
        
        /// Use a shadow file in conjunction with the data in the primary image file.
        ///
        /// This option prevents modification of the original image and allows read-only images to be attached read/write.
        /// When blocks are being read from the image, blocks present in the shadow file override blocks in the base image.
        /// All data written to an attached device will be redirected to the shadow file.
        /// If not specified, shadowfile defaults to image.shadow.
        /// If the shadow file does not exist, it is created.
        /// hdiutil verbs taking images as input accept `shadow`, `cacert`, and `insecurehttp`.
        case shadow(_ shadowFile: String)
        
        /// Ignore SSL host validation failures.
        ///
        /// Useful for self-signed servers for which the appropriate certificates are unavailable or if access to a server is desired when the server name doesn't match what is in the certificate.
        case insecureHTTP
        
        /// specify a certificate authority certificate.  
        ///
        /// `cert` can be either a PEM file or a directory of certificates processed by c\_rehash(1).\
        /// See also --capath and --cacert in curl(1).
        case cacert(_ fileOrDir: String)
        
        /// provide progress output that is easy for another program to parse.
        ///
        /// PERCENTAGE outputs can include the value -1 which means hdiutil is performing an operation that will  take an indeterminate amount of time to complete.  Any program trying to interpret hdiutil's progress should use `puppetStrings`.
        case puppetStrings
        
        /// provide result output in plist format.
        ///
        /// Other programs invoking hdiutil are expected to use `plist` rather than try to parse the human-readable output.
        /// The usual output is consistent but generally unstructured.
        case plist

        /// be verbose: produce extra progress output and error diagnostics.
        ///
        /// This option can help the user decipher why a particular operation failed.
        /// At a minimum, the probing of any specified images will be detailed.
        case verbose
        
        /// close stdout and stderr, leaving only hdiutil's exit status to indicate success or failure.
        ///
        /// `debug` and `verbose` disable `quiet`.
        case quiet
        
        /// be very verbose.  This option is good if a large amount of progress information is needed.
        ///
        /// As of macOS 10.6, `debug` enables `verbose`.
        case debug
    }
}
extension hdiutilClass.AttachImageOption: Codable, Hashable {
    public enum MontOption: String, Codable {
        case required, optional, suppressed
    }
}

extension [hdiutilClass.AttachImageOption] {
    var arguments: [String] {
        flatMap {
            switch $0 {
                case .readonly:
                    ["-readonly"]
                case .readwrite:
                    ["-readwrite"]
                case .kernel(let enabled):
                    [enabled ? "-kernel" : "-nokernel"]
                case .notremovable:
                    ["-notremovable"]
                case .mount(let option?):
                    [option.rawValue]
                case .mount(nil):
                    ["-nomount"]
                case .mountRoot(let path):
                    ["-mountroot", path]
                case .mountRandom(let path):
                    ["-mountrandom", path]
                case .mountPoint(let path):
                    ["-mountpoint", path]
                case .noBrowse:
                    ["-nobrowse"]
                case .owners(let flag):
                    ["-owners \(flag ? "on" : "off")"]
                case .driveKey(let key, let value):
                    ["-drivekey", "\(key)=\(value)"]
                    
                case .verify(let enabled):
                    ["-\(enabled ? "" : "no")verify"]
                case .ignoreBadChecksums(let enabled):
                    ["-\(enabled ? "" : "no")ignorebadchecksums"]
                case .idme(let enabled):
                    ["-\(enabled ? "" : "no")idme"]
                case .idmeReveal(let enabled):
                    ["-\(enabled ? "" : "no")idmereveal"]
                case .idmeTrash(let enabled):
                    ["-\(enabled ? "" : "no")idmetrash"]
                case .autoOpen(let enabled):
                    ["-\(enabled ? "" : "no")autoopen"]
                case .autoOpenReadonly(let enabled):
                    ["-\(enabled ? "" : "no")autoopenro"]
                case .autoOpenReadwrite(let enabled):
                    ["-\(enabled ? "" : "no")autoopenrw"]
                case .autoFileSystemChecking(let enabled):
                    ["-\(enabled ? "" : "no")autofsck"]
                    
                case .encryption(let method):
                    ["-encryption", method.rawValue]
                case .stdinPass:
                    ["-stdinpass"]
                case .agentPass:
                    ["-agentpass"]
                case .recover(let keychainFile):
                    ["-recover", keychainFile]
                case .imageKey(let key, let value):
                    ["-imagekey", "\(key)=\(value)"]
                case .shadow(let shadowFile):
                    ["-shadow", shadowFile]
                case .insecureHTTP:
                    ["-insecurehttp"]
                case .cacert(let fileOrDir):
                    ["-cacert", fileOrDir]
                case .puppetStrings:
                    ["-puppetstrings"]
                case .plist:
                    ["-plist"]
                case .verbose:
                    ["-verbose"]
                case .quiet:
                    ["-quiet"]
                case .debug:
                    ["-debug"]
                    
            }
        }
    }
    
    var stringValue: String {
        self.arguments
            .map {
                if $0.hasPrefix("-") {
                    return $0
                } else {
                    return "\"\($0)\""
                }
            }
            .joined(separator: " ")
    }
}

