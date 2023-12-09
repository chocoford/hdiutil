//
//  File.swift
//  
//
//  Created by Dove Zachary on 2023/11/3.
//

import Foundation

extension hdiutilClass {
    public enum CreateImageOption: HDIUtilOptions {
        // MARK: - Size specifiers
        
        /// Specify the size of the image in the style of mkfile(8) with the addition of tera-, peta-, and exa-bytes sizes (note that 'b' specifies a number of sectors, not bytes).  The larger sizes are useful for large sparse images.
        case size(Size)
        
        /// Specify the size of the image file in 512-byte sectors.
        case sectors(Int)
        
        /// Specify the size of the image file in megabytes (1024\*1024 bytes).
        case megabytes(Int)
        
        /// Equals to `-srcfolder` in hdiutil.\
        /// Copies file-by-file the contents of source into image, creating a fresh (theoretically defragmented) filesystem on the destination.
        ///
        /// The resulting image is thus recommended for use with asr(8) since it will have a minimal amount of unused space.
        /// Its size will be that of the source data plus some padding for filesystem overhead.
        /// The filesystem type of the image volume will match that of the source as closely as possible unless over-ridden with `fs`.
        /// Other size specifiers, such as `size`, will override the default size calculation based on the source content, allowing for more or less free space in the resulting filesystem.
        /// `srcFolder` can be specified more than once, in which case the image volume will be populated at the top level with a copy of each specified filesystem object.
        /// `srcdir` is a synonym.
        case srcFolder(String)
        
        case srcFolderURL(URL)

        
        /// Equals to `-srcdevice` in hdiutil.\
        /// Specifies that the blocks of device should be used to create a new image.
        ///
        /// The image size will match the size of device.  resize can be used to adjust the size of resizable filesystems and writable images.
        /// Both `srcDevice` and `srcFolder` can run into errors if there are bad blocks on a disk.
        /// One way around this problem is to write over the files in question in the hopes that the drive will remap the bad blocks.
        /// Data will be lost, but the image creation operation will subsequently succeed.
        /// Filesystem options (like `fs`, `volname`, `stretch`, or `size`) are invalid and ignored when using `srcDevice`.
        case srcDevice(String)
        
        
        /// specifies a size to which the final data partition will be aligned.  The default is 4K.
        case align(String)
        
        /// `type` is particular to create and is used to specify the format of empty read/write images.
        /// It is independent of `format` which is used to specify the final read-only image format when populating an image with pre-existing content.
        ///
        /// `UDIF` is the default type.  If specified, a UDRW of the specified size will be created.  SPARSE creates a UDSP: a read/write single-file image which expands as is is filled with data.  SPARSEBUNDLE creates a UDSB: a read/write image backed by a directory bundle.
        ///
        /// By default, `UDSP` images grow one megabyte at a time. Introduced in 10.5, UDSB images use 8 MB band files which grow as they are written to.  -imagekey sparse-band-size=size can be used to specify the number of 512-byte sectors that will be added each time the image grows.  Valid values for SPARSEBUNDLE range from 2048 to 16777216 sectors (1 MB to 8 GB).
        ///
        /// The maximum size of a `SPARSE` image is 128 petabytes; the maximum for SPARSEBUNDLE is just under 8 exabytes (2^63 - 512 bytes minus 1 byte).  The amount of data that can be stored in either type of sparse image is additionally bounded by the filesystem in the image and by any partition map.  compact can reclaim unused bands in sparse images backing HFS+ filesystems.  resize will only change the virtual size of a sparse image.  See also USING PERSISTENT SPARSE IMAGES below.
        case type(ImageType)
        
        /// filesystem is one of HFS+, HFS+J (JHFS+), HFSX, JHFS+X, MS-DOS, or UDF.
        ///
        ///  - fs causes a filesystem of the specified type to be written to the image.
        ///  - fs can change the partition scheme and type appropriately.
        ///  - fs will not make any size adjustments: if the image is the wrong size for the specified filesystem, create will fail.
        ///  - fs is invalid and ignored when using -srcdevice.
        case fs(FileSystem)
        
        /// The newly-created filesystem will be named volname.
        ///
        /// The default depends the filesystem being used;
        /// HFS+'s default volume name is `untitled`.  
        ///
        /// `volname` is invalid and ignored when using `srcdevice`.
        case volname(String)
        
        /// The root of the newly-created volume will be owned by the given numeric user id.
        ///
        /// 99 maps to the magic `unknown` user (see hdid(8)).
        case uid(Int)
        
        /// The root of the newly-created volume will be owned by the given numeric group id.
        ///
        /// 99 maps to `unknown`.
        case gid(Int)
        
        /// The root of the newly-created volume will have mode (in octal) mode.  
        ///
        /// The default mode is determined by the filesystem's newfs unless `srcfolder` is specified, 
        /// in which case the default mode is derived from the specified filesystem object.
        case mode(Mode)
        
        /// do [not] suppress automatically making backwards-compatible stretchable volumes when the volume size crosses the auto-stretch-size threshold (default: 256 MB).
        ///
        /// See also asr(8).
        case autoStretch(_ enabled: Bool)
        
        /// `stretch` initializes HFS+ filesystem data such that it can later be stretched on older systems (which could only stretch within predefined limits) using hdiutil resize or by asr(8).  max\_stretch is specified like `size`.
        ///
        /// `stretch` is invalid and ignored when using `srcdevice`.
        case stretch(Int)
        
        /// Additional arguments to pass to whatever newfs program is implied by `fs`.
        ///
        /// newfs\_hfs(8) has a number of options that can reduce the amount of space needed by the filesystem's data structures.  Suppressing the journal with -fs HFS+ and passing arguments such as -c c=64,a=16,e=16 to `fsargs` will minimize gaps at the front of the filesystem, allowing resize to squeeze more space from the filesystem. For truly optimal filesystems, use makehybrid.
        case fsargs(_ newfs_args: String)
        
        // MARK: - Image options
        
        /// Specify the partition layout of the image.
        ///
        ///  `layout` can be anything supported by MediaKit.framework. `NONE` creates an image with no partition map.  When such an image is attached, a single /dev entry will be created (e.g. /dev/disk1).
        ///
        /// `SPUD` causes a DDM and an Apple Partition Scheme partition map with a single entry to be written. `GPTSPUD` creates a similar image but with a GUID Partition Scheme map instead.  When attached, multiple /dev entries will be created, with either slice 1 (GPT) or slice 2 (APM) as the data partition. (e.g. /dev/disk1, /dev/disk1s1, /dev/disk1s2).
        ///
        /// Unless overridden by -fs, the default layout is `GPTSPUD` (PPC systems used `SPUD` prior to macOS 10.6).  Other layouts include `MBRSPUD` and `ISOCD`.
        case layout(Layout)
        
        /// Specify an alternate layout library.
        ///
        /// The default is MediaKit's MKDrivers.bundle.
        case library(String)
        
        /// Change the type of partition in a single-partition disk image.
        ///
        /// The default is `Apple_HFS` unless `fs` implies otherwise.
        case partitionType(String)
        
        /// Overwrite an existing file.
        ///
        /// The default is not to overwrite existing files.
        case overwrite
        
        /// attach the image after creating it.  
        ///
        /// If no filesystem is specified via `fs`,
        /// the attach will fail per the default attach `mount` required behavior.
        case attach
        
        // MARK: - Image from source options (for -srcfolder and -srcdevice):
        
        /// Specify the final image format.
        ///
        /// The default when a source is specified is `UDZO`.  format can be any of the format parameters used by convert.
        case format(Format)
        
        // MARK: - Options specific to `srcdevice`
        
        /// Specify that the image should be written in segments no bigger than size\_spec (which follows `size` conventions).
        @available(*, deprecated)
        case segmentSize
        
        // MARK: - Options specific to `srcfolder`
        
        /// do [not] cross device boundaries on the source filesystem
        case crossDev(_ flag: Bool)
        
        /// do [not] skip temporary files when imaging a volume.
        ///
        /// Scrubbing is the default when the source is the root of a mounted volume. 
        /// Scrubbed items include trashes, temporary directories, swap files, etc.
        case scrub(_ flag: Bool)
        
        /// do [not] fail if the user invoking hdiutil can't ensure correct file ownership for the files in the image.
        case anyowners(_ flag: Bool)
        
        /// skip files that can't be read by the copying user and don't authenticate.
        case skipUnreadable
        
        /// perform the copy as the given user.  Requires root privilege. 
        ///
        /// If user can't read or create files with the needed owners,
        /// `anyowners` or `skipunreadable` must be used to prevent the operation from failing.
        case copyUID(String)
        
        
        // MARK: - Commen options
        
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
        
        /// Force the default behavior of prompting for a passphrase.
        /// Useful with `pubkey` to create an image protected by both a passphrase and a public key.
        case agentPass
        
        /// Specify a secondary access certificate for an encrypted image.
        ///
        /// cert\_file must be DER-encoded certificate data, which can be created by Keychain Access or openssl(1).
        case certificate(String)
        
        /// Specify a list of public keys, identified by their hexa-decimal hashes, to be used to protect the encrypted image being created.
        case pubKey([String])
        
        case imageKey(_ key: String, _ value: String)
        
        /// Specify a key/value pair for any image created. (`imagekey` is only a synonym if there is no input image).
        case tgtimageKey(_ key: String, _ value: String)
        /// provide result output in plist format.
        ///
        /// Other programs invoking hdiutil are expected to use `plist` rather than try to parse the human-readable output.
        /// The usual output is consistent but generally unstructured.
        case plist
        /// provide progress output that is easy for another program to parse.  
        ///
        /// PERCENTAGE outputs can include the value -1 which means hdiutil is performing an operation that will  take an indeterminate amount of time to complete.  Any program trying to interpret hdiutil's progress should use `puppetStrings`.
        case puppetStrings
        case verbose
        case debug
        case quiet
    }
}

extension hdiutilClass.CreateImageOption {
    public enum Size: Codable, Hashable {
        /// number of sectors
        case b(Int)
        /// KiB
        case kb(Int)
        /// MiB
        case mb(Int)
        /// GiB
        case gb(Int)
        /// TiB
        case tb(Int)
        /// PiB
        case pb(Int)
        /// EiB
        case eb(Int)
        
        var stringValue: String {
            switch self {
                case .b(let value):
                    "\(value)b"
                case .kb(let value):
                    "\(value)k"
                case .mb(let value):
                    "\(value)m"
                case .gb(let value):
                    "\(value)g"
                case .tb(let value):
                    "\(value)t"
                case .pb(let value):
                    "\(value)p"
                case .eb(let value):
                    "\(value)e"
            }
        }
    }
    
//    public Alignment
    
    public enum ImageType: String, Codable {
        /// read/write disk image
        case udif = "UDIF"
        /// sparse disk image
        case sparse = "SPARSE"
        /// sparse bundle disk image
        case sparseBundle = "SPARSEBUNDLE"
        /// DVD/CD master
        case udto = "UDTO"
    }
    
    public enum FileSystem: String, Codable {
        /// HFS+
        case hfs = "HFS+"
        /// HFS+J (JHFS+)
        case jhfs = "HFS+J"
        /// HFSX
        case hfsx = "HFSX"
        /// JHFS
        case jhfsx = "JHFS+X"
        /// MS\_DOS
        case msdos = "MS_DOS"
        /// UDF
        case udf = "UDF"
    }
    
    public enum Mode: String, Codable {
        case u
    }
    
    public enum Layout: String, Codable {
        /// MBRSPUD - Single partition - Master Boot Record Partition Map
        case mbrspud = "MBRSPUD"
        /// SPUD - Single partition - Apple Partition Map
        case spud = "SPUD"
        /// UNIVERSAL CD - CD/DVD
        case universalCD = "UNIVERSAL CD"
        /// NONE - No partition map
        case none = "NONE"
        /// GPTSPUD - Single partition - GUID Partition Map
        case gptspud = "GPTSPUD"
        /// SPCD - Single partition - CD/DVD
        case spcd = "SPCD"
        /// UNIVERSAL HD - Hard disk
        case universalHD = "UNIVERSAL HD"
        /// ISOCD - Single partition - CD/DVD with ISO data
        case isocd = "ISOCD"
    }
    
//    public enum PartitionType: String, Codable {
//        
//    }
    
    public enum Format: String, Codable {
        /// UDRO - read-only
        case udro = "UDRO"
        /// UDCO - compressed (ADC)
        case udco = "UDCO"
        /// UDZO - compressed
        case udzo = "UDZO"
        /// UDBZ - compressed (bzip2), deprecated
        case udbz = "UDBZ"
        /// ULFO - compressed (lzfse)
        case ulfo = "ULFO"
        /// ULMO - compressed (lzma)
        case ulmo = "ULMO"
        /// UFBI - entire device
        case ufbi = "UFBI"
        /// IPOD - iPod image
        case ipod = "IPOD"
        /// UDSB - sparsebundle
        case udsb = "UDSB"
        /// UDSP - sparse
        case udsp = "UDSP"
        /// UDRW - read/write
        case udrw = "UDRW"
        /// UDTO - DVD/CD master
        case udto = "UDTO"
        /// UNIV - hybrid image (HFS+/ISO/UDF)
        case univ = "UNIV"
        /// SPARSEBUNDLE - sparse bundle disk image
        case sparseBundle = "SPARSEBUNDLE"
        /// SPARSE - sparse disk image
        case sparse = "SPARSE"
        /// UDIF - read/write disk image
        case udif = "UDIF"
    }
}


extension [hdiutilClass.CreateImageOption] {
    var arguments: [String] {
        return self.flatMap {
            switch $0 {
                case .size(let size):
                    return [size.stringValue]
                case .sectors(let count):
                    return ["-sectors", "\(count)"]
                case .megabytes(let size):
                    return ["-megabytes", "\(size)"]
                case .srcFolder(let source):
                    return ["-srcfolder", source]
                case .srcFolderURL(let url):
                    if #available(macOS 13.0, *) {
                        return ["-srcfolder", url.path(percentEncoded: false)]
                    } else {
                        return ["-srcfolder", url.path]
                    }
                case .srcDevice(let device):
                    return ["-srcdevice", "\(device)"]
                case .align(let alignment):
                    return ["-align", "\(alignment)"]
                case .type(let type):
                    return ["-type", type.rawValue]
                case .fs(let fileSystem):
                    return ["-fs", fileSystem.rawValue]
                case .volname(let name):
                    return ["-volname", name]
                case .uid(let id):
                    return ["-uid", "\(id)"]
                case .gid(let id):
                    return ["-gid", "\(id)"]
                case .mode(let mode):
                    return ["-mode", "\(mode)"]
                case .autoStretch(let enabled):
                    return ["\(enabled ? "" : "no")autostretch"]
                case .stretch(let maxStretch):
                    return ["-stretch", "\(maxStretch)"]
                case .fsargs(let args):
                    return ["-fsargs", args]
                case .layout(let layout):
                    return ["-layout", "\(layout.rawValue)"]
                case .library(let bundle):
                    return ["-library", "\(bundle)"]
                case .partitionType(let type):
                    return ["-partitionType", "\(type)"]
                case .overwrite:
                    return ["-ov"]
                case .attach:
                    return ["-attach"]
                case .format(let format):
                    return ["-format", format.rawValue]
                case .segmentSize:
                    return []
                case .crossDev(let enabled):
                    return ["-\(enabled ? "" : "no")crossdev"]
                case .scrub(let enabled):
                    return ["-\(enabled ? "" : "no")scrub"]
                case .anyowners(let enabled):
                    return ["-\(enabled ? "" : "no")anyowners"]
                case .skipUnreadable:
                    return ["-skipunreadable"]
                case .copyUID(let user):
                    return ["copyuid", "\(user)"]
                case .encryption(let method):
                    return ["-encryption", "\(method.rawValue)"]
                case .stdinPass:
                    return ["-stdinpass"]
                case .agentPass:
                    return ["-agentpass"]
                case .certificate(let cert):
                    return ["-certificate", "\(cert)"]
                case .pubKey(let keys):
                    return ["-pubkey", "\(keys.map{$0}.joined(separator: " "))"]
                case .imageKey(let key, let value):
                    return ["-imagekey", "\(key)=\(value)"]
                case .tgtimageKey(let key, let value):
                    return ["-tgtimagekey", "\(key)=\(value)"]
                case .plist:
                    return ["-plist"]
                case .puppetStrings:
                    return ["-puppetstrings"]
                case .verbose:
                    return ["-verbose"]
                case .debug:
                    return ["-debug"]
                case .quiet:
                    return ["-quiet"]
            }
        }
    }
    
    var stringValue: String {
        self
            .arguments
            .map {
                if $0.hasPrefix("-") && !$0.hasPrefix("-c ") {
                    return $0
                } else {
                    return "\"\($0)\""
                }
            }
            .joined(separator: " ")
    }
}
