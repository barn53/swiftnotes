struct Interval {
    var type: IntervalType
    var modifier: IntervalModifier

    init() {

        self.type = IntervalType.Prim
        self.modifier = IntervalType.Prim.values.baseModifier

    }

    init(type: IntervalType, modifier: IntervalModifier) {
        self.type = type
        self.modifier = modifier
    }

    var validate: Bool {
        if type.values.baseModifier == .groß {
            if modifier == .rein ||
                modifier == .tritonus ||
                modifier == .doppeltVermindert {
                    return false
            }
        }

        if type.values.baseModifier == .rein {
            if modifier == .groß ||
                modifier == .klein {
                    return false
            }
        }

        if modifier == .tritonus &&
            (type != .Quinte && type != .Quarte) {
                return false
        }

        return true
    }

    var semitones: Int {
        var st = 0

        switch modifier {
        case .vermindert:
            if (type.values.baseModifier == .rein) {
                st = type.values.semitones - 1
            }
            else {
                st = type.values.semitones - 2
            }
        case .doppeltVermindert:
            if (type.values.baseModifier == .rein) {
                st = type.values.semitones - 2
            }
        case .tritonus:
            if (type == .Quarte) {
                st = type.values.semitones + 1
            }
            else if (type == .Quinte) {
                st = type.values.semitones - 1
            }
        default:
            st = type.values.semitones + modifier.values.semitones
        }

        return st
    }

    var name: String {
        if !validate {
            return "Fehler: \(type.values.name) \(modifier.values.name)"
        }
        if modifier == .tritonus || semitones == 6 {
            return "Tritonus"
        }
        return "\(type.values.name) \(modifier.values.name)"
    }

    var describe: String {
        return "\(name), lines: \(type.values.lines), semitones: \(semitones)"
    }

    static func determineFromNote(note1: Note, note2: Note) -> Interval? {

        let deltaLines = abs(note1.line - note2.line)
        let deltaSemitones = abs(note1.semitones - note2.semitones)
        let octaves = deltaSemitones / 12
        var remainLines = deltaLines
        var remainSemitones = deltaSemitones
        if deltaLines > 7 {
            remainLines = deltaLines % 7
            remainSemitones = deltaSemitones % 12
        }

        println("\(note1.name) ~       \(note2.name)")
        println("deltaLines:           \(deltaLines)")
        println("deltaSemitones:       \(deltaSemitones)")

        if deltaLines > 7 {
            println("octaves:              \(octaves)")
            println("remainLines:          \(remainLines)")
            println("remainSemitones:      \(remainSemitones)")
        }

        var i = Interval()
        if let type = IntervalType.intervalTypeForDeltaLines(remainLines) {
            i.type = type
            let modifySemitones = remainSemitones - type.values.semitones
            println("modifySemitones: \(modifySemitones)")
            if let modifier = IntervalModifier.intervalModifierForModifySemitones(modifySemitones, baseModifier: type.values.baseModifier) {
                i.modifier = modifier
            }
        }
        return i
    }
}
