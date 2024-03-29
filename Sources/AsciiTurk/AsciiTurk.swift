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

public func asciiTurk(
    _ asciiString: String,
    spaceStrings: [String] = [
        "\u{00020}", // 00032
        "\u{0002D}", // 00045 -
        "\u{0005F}", // 00095 _
    ],
    caseInsensitive: Bool = true,
    fricativeInsensitive: Bool = true,
    passthrough: Bool = false) -> String {
    var asciiString = asciiString
    if caseInsensitive {
        asciiString = asciiString.lowercased()
    }
    var turkString = ""
    var backness: Backness? = nil
    var articulation: String? = nil
    var implicit = false
    var space = false
    for asciiInput in asciiString.unicodeScalars {
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
                    if let turkLetter = asciiSpaceTurkSpace["\u{00020}"] { // 00032
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
        } else if passthrough {
            turkString += asciiLetter
        }
    }
    return turkString
}

let asciiSpaceTurkSpace = [
    "\u{00020}": // 00032
        "\u{0003A}", // 00058 :
]

let asciiTurk = [
    "\u{00061}": Letter( // 00097 a
        back: "\u{10C00}", // 68608
        front: "\u{10C00}", // 68608
        backness: .back,
        implicit: true),
    "\u{00065}": Letter( // 00101 e
        back: "\u{10C00}", // 68608
        front: "\u{10C00}", // 68608
        backness: .front,
        implicit: true),
    "\u{00077}": Letter( // 00119 w
        back: "\u{10C03}", // 68611
        front: "\u{10C03}", // 68611
        backness: .back,
        implicit: false),
    "\u{00069}": Letter( // 00105 i
        back: "\u{10C03}", // 68611
        front: "\u{10C03}", // 68611
        backness: .front,
        implicit: false),
    "\u{0006F}": Letter( // 00111 o
        back: "\u{10C06}", // 68614
        front: "\u{10C06}", // 68614
        backness: .back,
        implicit: false),
    "\u{00075}": Letter( // 00117 u
        back: "\u{10C07}", // 68615
        front: "\u{10C07}", // 68615
        backness: .front,
        implicit: false),
    "\u{0006B}": Letter( // 00107 k
        back: "\u{10C34}", // 68660
        front: "\u{10C1A}", // 68634
        backness: nil,
        implicit: false),
    "\u{00063}": Letter( // 00099 c
        back: "\u{10C32}", // 68658
        front: "\u{10C32}", // 68658
        backness: nil,
        implicit: false),
    "\u{00074}": Letter( // 00116 t
        back: "\u{10C43}", // 68675
        front: "\u{10C45}", // 68677
        backness: nil,
        implicit: false),
    "\u{00070}": Letter( // 00112 p
        back: "\u{10C2F}", // 68655
        front: "\u{10C2F}", // 68655
        backness: nil,
        implicit: false),
    "\u{00067}": Letter( // 00103 g
        back: "\u{10C0D}", // 68621
        front: "\u{10C0F}", // 68623
        backness: nil,
        implicit: false),
    "\u{00064}": Letter( // 00100 d
        back: "\u{10C11}", // 68625
        front: "\u{10C13}", // 68627
        backness: nil,
        implicit: false),
    "\u{00062}": Letter( // 00098 b
        back: "\u{10C09}", // 68617
        front: "\u{10C0B}", // 68619
        backness: nil,
        implicit: false),
    "\u{00078}": Letter( // 00120 x
        back: "\u{10C41}", // 68673
        front: "\u{10C40}", // 68672
        backness: nil,
        implicit: false),
    "\u{00073}": Letter( // 00115 s
        back: "\u{10C3D}", // 68669
        front: "\u{10C3E}", // 68670
        backness: nil,
        implicit: false),
    "\u{0007A}": Letter( // 00122 z
        back: "\u{10C14}", // 68628
        front: "\u{10C14}", // 68628
        backness: nil,
        implicit: false),
    "\u{00071}": Letter( // 00113 q
        back: "\u{10C2C}", // 68652
        front: "\u{10C2D}", // 68653
        backness: nil,
        implicit: false),
    "\u{0006A}": Letter( // 00106 j
        back: "\u{10C2A}", // 68650
        front: "\u{10C2A}", // 68650
        backness: nil,
        implicit: false),
    "\u{0006E}": Letter( // 00110 n
        back: "\u{10C23}", // 68643
        front: "\u{10C24}", // 68644
        backness: nil,
        implicit: false),
    "\u{0006D}": Letter( // 00109 m
        back: "\u{10C22}", // 68642
        front: "\u{10C22}", // 68642
        backness: nil,
        implicit: false),
    "\u{00072}": Letter( // 00114 r
        back: "\u{10C3A}", // 68666
        front: "\u{10C3C}", // 68668
        backness: nil,
        implicit: false),
    "\u{00079}": Letter( // 00121 y
        back: "\u{10C16}", // 68630
        front: "\u{10C18}", // 68632
        backness: nil,
        implicit: false),
    "\u{0006C}": Letter( // 00108 l
        back: "\u{10C1E}", // 68638
        front: "\u{10C20}", // 68640
        backness: nil,
        implicit: false),
]

let asciiFricativeAsciiOcclusive = [
    "\u{00068}": // 00104 h
        "\u{0006B}", // 00107 k
    "\u{00066}": // 00102 f
        "\u{00070}", // 00112 p
    "\u{00076}": // 00118 v
        "\u{00062}", // 00098 b
]
