enum Backness {
    case back
    case front
}

struct Letter {
    var back: String
    var front: String
    var backness: Backness?
    var implicit: Bool
}

public func asciiTurk(_ asciiString: String, spaceStrings: [String] = ["\u{00020}", "\u{0002d}", "\u{0005f}"], caseInsensitive: Bool = false, fricativeInsensitive: Bool = false) -> String {
    var asciiString = asciiString
    if caseInsensitive {
        asciiString = asciiString.lowercased()
    }
    var turkString = ""
    var backness: Backness? = nil
    var implicit = false
    var i = 0
    while i < asciiString.count {
        let asciiIndex = asciiString.index(asciiString.startIndex, offsetBy: i)
        var asciiLetter = String(asciiString[asciiIndex])
        if fricativeInsensitive {
            if let occlusiveLetter = asciiFricativeAsciiOcclusive[asciiLetter] {
                asciiLetter = occlusiveLetter
            }
        }
        var spaceLetter = false
        for spaceString in spaceStrings {
            if asciiLetter == String(spaceString) {
                if i + 1 < asciiString.count {
                    let asciiIndex = asciiString.index(asciiString.startIndex, offsetBy: i + 1)
                    let asciiLetter = String(asciiString[asciiIndex])
                    if asciiLetter == String(spaceString) {
                        if let turkLetter = asciiTurk["\u{00020}"] {
                            turkString += turkLetter.back
                        }
                    }
                }
                spaceLetter = true
            }
        }
        if spaceLetter {
            backness = nil
            turkString += ""
        } else if let turkLetter = asciiTurk[asciiLetter] {
            if let newBackness = turkLetter.backness {
                if newBackness != backness {
                    backness = newBackness
                    implicit = turkLetter.implicit
                }
            }
            if backness == nil {
                var j = i + 1
                while j < asciiString.count {
                    let asciiIndex = asciiString.index(asciiString.startIndex, offsetBy: j)
                    let asciiLetter = String(asciiString[asciiIndex])
                    if let turkLetter = asciiTurk[asciiLetter] {
                        if turkLetter.backness != nil {
                            backness = turkLetter.backness
                            implicit = turkLetter.implicit
                            break
                        }
                    }
                    j += 1
                }
            }
            if !(turkLetter.implicit && implicit) {
                switch backness {
                case nil:
                    turkString += ""
                case .back:
                    turkString += turkLetter.back
                case .front:
                    turkString += turkLetter.front
                }
            }
            if turkLetter.implicit {
                implicit = false
            }
        }
        i += 1
    }
    return turkString
}

let asciiTurk = [
    "\u{00020}": Letter(
        back: "\u{0003a}",
        front: "\u{0003a}",
        backness: nil,
        implicit: false),
    "\u{00061}": Letter(
        back: "\u{10c00}",
        front: "\u{10c00}",
        backness: .back,
        implicit: true),
    "\u{00065}": Letter(
        back: "\u{10c00}",
        front: "\u{10c00}",
        backness: .front,
        implicit: true),
    "\u{00077}": Letter(
        back: "\u{10c03}",
        front: "\u{10c03}",
        backness: .back,
        implicit: false),
    "\u{00069}": Letter(
        back: "\u{10c03}",
        front: "\u{10c03}",
        backness: .front,
        implicit: false),
    "\u{0006f}": Letter(
        back: "\u{10c06}",
        front: "\u{10c06}",
        backness: .back,
        implicit: false),
    "\u{00075}": Letter(
        back: "\u{10c07}",
        front: "\u{10c07}",
        backness: .front,
        implicit: false),
    "\u{00062}": Letter(
        back: "\u{10c09}",
        front: "\u{10c0b}",
        backness: nil,
        implicit: false),
    "\u{00067}": Letter(
        back: "\u{10c0d}",
        front: "\u{10c0f}",
        backness: nil,
        implicit: false),
    "\u{00064}": Letter(
        back: "\u{10c11}",
        front: "\u{10c13}",
        backness: nil,
        implicit: false),
    "\u{0007a}": Letter(
        back: "\u{10c14}",
        front: "\u{10c14}",
        backness: nil,
        implicit: false),
    "\u{00079}": Letter(
        back: "\u{10c16}",
        front: "\u{10c18}",
        backness: nil,
        implicit: false),
    "\u{0006b}": Letter(
        back: "\u{10c34}",
        front: "\u{10c1a}",
        backness: nil,
        implicit: false),
    "\u{0006c}": Letter(
        back: "\u{10c1e}",
        front: "\u{10c20}",
        backness: nil,
        implicit: false),
    "\u{0006d}": Letter(
        back: "\u{10c22}",
        front: "\u{10c22}",
        backness: nil,
        implicit: false),
    "\u{0006e}": Letter(
        back: "\u{10c23}",
        front: "\u{10c24}",
        backness: nil,
        implicit: false),
    "\u{0006a}": Letter(
        back: "\u{10c2a}",
        front: "\u{10c2a}",
        backness: nil,
        implicit: false),
    "\u{00071}": Letter(
        back: "\u{10c2c}",
        front: "\u{10c2d}",
        backness: nil,
        implicit: false),
    "\u{00070}": Letter(
        back: "\u{10c2f}",
        front: "\u{10c2f}",
        backness: nil,
        implicit: false),
    "\u{00063}": Letter(
        back: "\u{10c32}",
        front: "\u{10c32}",
        backness: nil,
        implicit: false),
    "\u{00072}": Letter(
        back: "\u{10c3a}",
        front: "\u{10c3c}",
        backness: nil,
        implicit: false),
    "\u{00073}": Letter(
        back: "\u{10c3d}",
        front: "\u{10c3e}",
        backness: nil,
        implicit: false),
    "\u{00078}": Letter(
        back: "\u{10c41}",
        front: "\u{10c40}",
        backness: nil,
        implicit: false),
    "\u{00074}": Letter(
        back: "\u{10c43}",
        front: "\u{10c45}",
        backness: nil,
        implicit: false)
]

let asciiFricativeAsciiOcclusive = [
    "\u{00076}": "\u{00062}",
    "\u{00068}": "\u{0006b}",
    "\u{00066}": "\u{00070}",
]
