# hdiutil
![GitHub](https://img.shields.io/github/license/chocoford/hdiutil) [![Twitter](https://img.shields.io/twitter/url/https/twitter.com/cloudposse.svg?style=social&label=Follow%20%40Chocoford)](https://twitter.com/dove_zachary)

A WIP hdiutil helper in swift language. For more information, please visit [apple docs](https://ss64.com/osx/hdiutil.html). 

> `hdiutil` is a command-line utility in macOS that allows users to manipulate disk images. It is a versatile tool included with the macOS operating system and provides a wide range of capabilities for creating, converting, mounting, unmounting, and inspecting disk images. Disk images are virtual disks that can contain file systems and data, typically having a .dmg or .iso file extension.

## Installation

```
.package(url: "https://github.com/chocoford/hdiutil.git", branch: "main")
```

## Usage

#### Create dmg

```swift
try await hdiutil.create(
    image: "MyDMG.dmg",
    options: [
        .srcFolder(...),
        .volname(...),
        .overwrite
    ]
)
```

#### Attach dmg

```swift
let attachOutput = try await hdiutil.attach(image: ..., options: [
    .mountRandom("/tmp"),
    .readwrite,
    .verify(false),
    .autoOpen(false),
    .noBrowse
])
let deviceName = attachOutput.deviceNode
let mountURL = attachOutput.mountPoint
```




## Roadmap

- [x] attach
- [x] detach
- [ ] verify
- [x] create
- [x] convert
- [ ] burn
- [ ] makeHybrid
- [ ] compact
- [x] info
- [ ] checksum
- [ ] chpass
- [ ] eraseKeys
- [ ] unflatten
- [ ] flatten
- [ ] fsid
- [ ] mountVol
- [ ] unmount
- [ ] imageInfo
- [ ] isencrypted
- [ ] plugins
- [ ] internetEnable
- [x] resize
- [ ] segment
- [ ] pmap
- [x] udifrez
- [ ] udifderez


## See Aso

