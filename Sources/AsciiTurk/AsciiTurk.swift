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

public func asciiTurk(_ asciiString: String, spaceStrings: [String] = ["\u{00020}", "\u{0002D}", "\u{0005F}"], caseInsensitive: Bool = true, fricativeInsensitive: Bool = true) -> String {
    var asciiString = asciiString
    if caseInsensitive {
        asciiString = asciiString.lowercased()
    }
    var turkString = ""
    var backness: Backness? = nil
    var articulation: String? = nil
    var implicit = false
    var space = false
    for asciiInput in asciiString {
        var asciiLetter = String(asciiInput)
        if fricativeInsensitive {
            if let occlusiveLetter = asciiFricativeAsciiOcclusive[asciiLetter] {
                asciiLetter = occlusiveLetter
            }
        }
        var spaceLetter = false
        for spaceString in spaceStrings {
            if asciiLetter == String(spaceString) {
                if space {
                    if let turkLetter = asciiSpaceTurkSpace["\u{00020}"] {
                        turkString += turkLetter
                    }
                }
                spaceLetter = true
            }
        }
        if spaceLetter {
            backness = nil
            articulation = nil
            implicit = false
            if space {
                space = false
            } else {
                space = true
            }
            turkString += ""
        } else if let turkLetter = asciiTurk[asciiLetter] {
            if let newBackness = turkLetter.backness {
                if newBackness != backness {
                    backness = newBackness
                    implicit = turkLetter.implicit
                }
            }
            switch backness {
            case nil:
                if turkLetter.backness == nil {
                    articulation = asciiLetter
                }
            case .back:
                switch articulation {
                case nil:
                    turkString += ""
                case .some(let articulationValue):
                    if let articulationLetter = asciiTurk[articulationValue] {
                        turkString += articulationLetter.back
                        articulation = nil
                    }
                }
            case .front:
                switch articulation {
                case nil:
                    turkString += ""
                case .some(let articulationValue):
                    if let articulationLetter = asciiTurk[articulationValue] {
                        turkString += articulationLetter.front
                        articulation = nil
                    }
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
            space = false
        }
    }
    return turkString
}

let asciiSpaceTurkSpace = [
    "\u{00020}": "\u{0003A}",
]

let asciiTurk = [
    "\u{00061}": Letter(
        back: "\u{10C00}",
        front: "\u{10C00}",
        backness: .back,
        implicit: true),
    "\u{00065}": Letter(
        back: "\u{10C00}",
        front: "\u{10C00}",
        backness: .front,
        implicit: true),
    "\u{00077}": Letter(
        back: "\u{10C03}",
        front: "\u{10C03}",
        backness: .back,
        implicit: false),
    "\u{00069}": Letter(
        back: "\u{10C03}",
        front: "\u{10C03}",
        backness: .front,
        implicit: false),
    "\u{0006F}": Letter(
        back: "\u{10C06}",
        front: "\u{10C06}",
        backness: .back,
        implicit: false),
    "\u{00075}": Letter(
        back: "\u{10C07}",
        front: "\u{10C07}",
        backness: .front,
        implicit: false),
    "\u{0006B}": Letter(
        back: "\u{10C34}",
        front: "\u{10C1A}",
        backness: nil,
        implicit: false),
    "\u{00067}": Letter(
        back: "\u{10C0D}",
        front: "\u{10C0F}",
        backness: nil,
        implicit: false),
    "\u{00063}": Letter(
        back: "\u{10C32}",
        front: "\u{10C32}",
        backness: nil,
        implicit: false),
    "\u{00074}": Letter(
        back: "\u{10C43}",
        front: "\u{10C45}",
        backness: nil,
        implicit: false),
    "\u{00064}": Letter(
        back: "\u{10C11}",
        front: "\u{10C13}",
        backness: nil,
        implicit: false),
    "\u{00070}": Letter(
        back: "\u{10C2F}",
        front: "\u{10C2F}",
        backness: nil,
        implicit: false),
    "\u{00062}": Letter(
        back: "\u{10C09}",
        front: "\u{10C0B}",
        backness: nil,
        implicit: false),
    "\u{00078}": Letter(
        back: "\u{10C41}",
        front: "\u{10C40}",
        backness: nil,
        implicit: false),
    "\u{00073}": Letter(
        back: "\u{10C3D}",
        front: "\u{10C3E}",
        backness: nil,
        implicit: false),
    "\u{0007A}": Letter(
        back: "\u{10C14}",
        front: "\u{10C14}",
        backness: nil,
        implicit: false),
    "\u{00071}": Letter(
        back: "\u{10C2C}",
        front: "\u{10C2D}",
        backness: nil,
        implicit: false),
    "\u{0006A}": Letter(
        back: "\u{10C2A}",
        front: "\u{10C2A}",
        backness: nil,
        implicit: false),
    "\u{0006E}": Letter(
        back: "\u{10C23}",
        front: "\u{10C24}",
        backness: nil,
        implicit: false),
    "\u{0006D}": Letter(
        back: "\u{10C22}",
        front: "\u{10C22}",
        backness: nil,
        implicit: false),
    "\u{00072}": Letter(
        back: "\u{10C3A}",
        front: "\u{10C3C}",
        backness: nil,
        implicit: false),
    "\u{00079}": Letter(
        back: "\u{10C16}",
        front: "\u{10C18}",
        backness: nil,
        implicit: false),
    "\u{0006C}": Letter(
        back: "\u{10C1E}",
        front: "\u{10C20}",
        backness: nil,
        implicit: false),
]

let asciiFricativeAsciiOcclusive = [
    "\u{00068}": "\u{0006B}",
    "\u{00066}": "\u{00070}",
    "\u{00076}": "\u{00062}",
]
