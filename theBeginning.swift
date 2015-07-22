
/*******************************************************************/
enum Grundton {
    case c, d, e, f, g, a, h

    var values: (name: String, baseLine: Int, semitones: Int) {
        switch self {
            case c:
                return ("c", 0, 0)
            case d:
                return ("d", 1, 2)
            case e:
                return ("e", 2, 4)
            case f:
                return ("f", 3, 5)
            case g:
                return ("g", 4, 7)
            case a:
                return ("a", 5, 9)
            case h:
                return ("h", 6, 11)
        }
    }
}

// ♯ ♭

enum Vorzeichen {
    case ohne, be, doppelBe, kreuz, doppelKreuz
    
    var values: (name: String, deltaSemitones: Int) {
        switch self {
            case ohne:
                return ("", 0)
            case be:
                return ("♭", -1)
            case doppelBe:
                return ("♭♭", -2) // UTF-8: �
            case kreuz:
                return ("♯", 1)
            case doppelKreuz:
                return ("♯♯", 2)  // UTF-8: �
        }
    }
}

enum Oktave {
    case subsubkontra, subkontra, kontra, groß, klein, 
    eingestrichen, zweigestrichen, dreigestrichen, viergestrichen, fünfgestrichen
    // die eingestrichene ist das c' auf der ersten Hilfslinie unten im Violinschlüssel
    
    var values: (lineDelta: Int, ordinal: Int, upper: Bool, postPräfix: String) {
        switch self {
            case .subsubkontra:
                return (-35, -5, true, ",,,")
            case .subkontra:
                return (-28, -4, true, ",,")
            case .kontra:
                return (-21, -3, true, ",")
            case .groß:
                return (-14, -2, true, "")
            case .klein:
                return (-7, -1, false, "")
            case .eingestrichen:
                return (0, 0, false, "'")
            case .zweigestrichen:
                return (7, 1, false, "''")
            case .dreigestrichen:
                return (14, 2, false, "'''")
            case .viergestrichen:
                return (21, 3, false, "''''")
            case .fünfgestrichen:
                return (28, 4, false, "'''''")
        }
    }
}

enum Notenschlüssel {
    case violin, bass
    
    var values: (name: String, lineDelta: Int) {
        switch self {
            case .violin:
                return ("Violinschlüssel", 0)
            case .bass:
                return ("Bassschlüssel", 12)
        }
    }
}

// Meine Definition:        --12--
// ---------------------10-----------------
// ------------------8---------------------
// ---------------6------------------------
// ------------4---------------------------
// ---------2------------------------------
//     --0--   <-- Linie 0 Bezugspunkt (Violinschlüssel c')

struct Note {
    var grundTon = Grundton.c
    var vorzeichen = Vorzeichen.ohne
    var oktave = Oktave.eingestrichen

    var line: Int {
        return grundTon.values.baseLine + oktave.values.lineDelta
    }
    
    var semitones: Int {
        return grundTon.values.semitones + vorzeichen.values.deltaSemitones + (oktave.values.ordinal * 12)
    }
    
    var name: String {
        return oktave.values.upper
        ? 
        oktave.values.postPräfix + grundTon.values.name.uppercaseString + vorzeichen.values.name
        :
        grundTon.values.name + vorzeichen.values.name + oktave.values.postPräfix
    }
    var describe: String {
        return "\(name) - Halbtöne: \(semitones), Linie: \(line)"
    }
}

enum IntervalModifier {
    case rein, groß, klein, übermäßig, doppeltÜbermäßig, vermindert, doppeltVermindert, tritonus

    var values: (name: String, semitones: Int) {
        switch self {
            case rein:              return ("rein",                0) // perfect
            case groß:              return ("groß",                0) // major
            case klein:             return ("klein",              -1) // minor
            case übermäßig:         return ("übermäßig",           1) // augmented
            case doppeltÜbermäßig:  return ("doppelt übermäßig",   2) // double augmented
            case vermindert:        return ("vermindert",          100) // -1 bei reinen, -2 bei großen Grundintervallen // dimished
            case doppeltVermindert: return ("doppelt vermindert",  100) // -2 bei reinen, ungültig bei großen Grundintervallen // double dimished
            case tritonus:          return ("tritonus",            100) // +1 bei Quarte, -1 bei Quinte // tritone
        }
    }
    
    static func intervalModifierForModifySemitones(semitones: Int, baseModifier: IntervalModifier) -> IntervalModifier? {
        switch baseModifier {
            case .rein:
                switch semitones {
                    case 0:
                        return .rein
                    case -1:
                        return .vermindert
                    case -2:
                        return .doppeltVermindert
                    case 1:
                        return .übermäßig
                    case 2:
                        return .doppeltÜbermäßig
                    default:
                        return nil
                }
            case .groß:
                switch semitones {
                    case 0:
                        return .groß
                    case -1:
                        return .klein
                    case -2:
                        return .vermindert
                    case 1:
                        return .übermäßig
                    case 2:
                        return .doppeltÜbermäßig
                    default:
                        return nil
                }
            default:
                return nil
        }
    }
}

enum IntervalType {
    case Prim, Second, Terz, Quarte, Quinte, Sexte, Septime, Oktave
    
    var values: (name: String, lines: Int, semitones: Int, baseModifier: IntervalModifier) {
        switch self {
            case Prim:     return ("Prim",   0, 0,  .rein)  // unison
            case Second:   return ("Second", 1, 2,  .groß)  // 2nd
            case Terz:     return ("Terz",   2, 4,  .groß)  // 3rd
            case Quarte:   return ("Quarte", 3, 5,  .rein)  // 4th
            case Quinte:   return ("Quinte", 4, 7,  .rein)  // 5th
            case Sexte:    return ("Sexte",  5, 9,  .groß)  // 6th
            case Septime:  return ("Septe",  6, 11, .groß)  // 7th
            case Oktave:   return ("Oktave", 7, 12, .rein)  // octave
        }
    }
    
    static func intervalTypeForDeltaLines(lines: Int) -> IntervalType? {
        switch lines {
            case 0:
                return .Prim
            case 1:
                return .Second
            case 2:
                return .Terz
            case 3:
                return .Quarte
            case 4:
                return .Quinte
            case 5:
                return .Sexte
            case 6:
                return .Septime
            case 7:
                return .Oktave
            default:
                return nil
        }
    }
}

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


enum Akkord {
    
}


enum Tonleiter {
    
}

var c = Note()
var a = Note()
var C = Note()
var f = Note()
var Fis = Note()
a.grundTon = .a
C.oktave = .groß
f.grundTon = .f
Fis.grundTon = .f
Fis.oktave = .groß
Fis.vorzeichen = .kreuz

println("------------------------")
println(c.describe)
println(a.describe)
println(C.describe)
println(f.describe)
println(Fis.describe)

println("------------------------")
var i = Interval.determineFromNote(f, note2: a)
println(i!.name)

println("------------------------")
i = Interval.determineFromNote(Fis, note2: c)
println(i!.name)

println("------------------------")
i = Interval.determineFromNote(Fis, note2: C)
println(i!.name)

println("------------------------")
i = Interval.determineFromNote(c, note2: C)
println(i!.name)

var A = Note()
A.grundTon = .a
A.oktave = .klein
var aisis = Note()
aisis.grundTon = .a
aisis.vorzeichen = .doppelKreuz
println("------------------------")
i = Interval.determineFromNote(A, note2: aisis)
println(i!.name)


var terz  = Interval(type: .Terz, modifier: .groß)
var tri   = Interval(type: .Quinte, modifier: .vermindert)
var tri2  = Interval(type: .Quarte, modifier: .übermäßig)
var tri3  = Interval(type: .Quarte, modifier: .tritonus)
var tri4  = Interval(type: .Quinte, modifier: .tritonus)
var tri5  = Interval(type: .Prim, modifier: .tritonus)
var quarte  = Interval(type: .Quarte, modifier: .doppeltVermindert)

// print("\(terz.describe)\n")
// print("\(tri.describe)\n")
// print("\(tri2.describe)\n")
// print("\(tri3.describe)\n")
// print("\(tri4.describe)\n")
// print("\(tri5.describe)\n")
// print("\(quarte.describe)\n")


var d = Note()
var fis = Note()

d.grundTon = .d

fis.grundTon = .f
fis.vorzeichen = .kreuz

// println(d.describe)
// println(fis.describe)





/*

 Was will ich berechnen können?
 
 - Intervall aus zwei Noten bestimmen
 - zweite Note aus erster Note und Intervall
 
 - Akkord aus drei oder vier Noten bestimmen
 - Folgenoten aus Grund-Note und Akkord
 
 - Tonleiter-Noten aus Grund-Note und Tonleiter erzeugen
 - Tonleiter aus Noten bestimmen 

*/

























