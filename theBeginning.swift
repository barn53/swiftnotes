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
}

// ♯ ♭


struct Interval {
    var type = IntervalType.Prim
    var modifier = IntervalType.Prim.values.baseModifier
    
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
        return "\(name) (\(type.values.lines) , \(semitones))"
    }
}

var terz  = Interval(type: .Terz, modifier: .groß)
var tri   = Interval(type: .Quinte, modifier: .vermindert)
var tri2  = Interval(type: .Quarte, modifier: .übermäßig)
var tri3  = Interval(type: .Quarte, modifier: .tritonus)
var tri4  = Interval(type: .Quinte, modifier: .tritonus)
var tri5  = Interval(type: .Prim, modifier: .tritonus)
var quarte  = Interval(type: .Quarte, modifier: .doppeltVermindert)

print("\(terz.describe)\n")
print("\(tri.describe)\n")
print("\(tri2.describe)\n")
print("\(tri3.describe)\n")
print("\(tri4.describe)\n")
print("\(tri5.describe)\n")
print("\(quarte.describe)\n")


/*******************************************************************/
enum Grundton {
    case c, d, e, f, g, a, h

    var values: (name: String, line: Int, semitones: Int) {
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
    case subsubkontra, subkontra, kontra, große, kleine, 
    eingestrichene, zweigestrichene, dreigestrichene, viergestrichene, fünfgestrichene
    // die eingestrichene ist das c' auf der ersten Hilfslinie unten im Violinschlüssel
    
    var values: (lineDelta: Int, upper: Bool, postPräfix: String) {
        switch self {
            case .subsubkontra:
                return (-35, true, ",,,")
            case .subkontra:
                return (-28, true, ",,")
            case .kontra:
                return (-21, true, ",")
            case .große:
                return (-14, true, "")
            case .kleine:
                return (-7, false, "")
            case .eingestrichene:
                return (0, false, "'")
            case .zweigestrichene:
                return (7, false, "''")
            case .dreigestrichene:
                return (14, false, "'''")
            case .viergestrichene:
                return (21, false, "''''")
            case .fünfgestrichene:
                return (28, false, "'''''")
        }
    }
}

enum Notenschlüssel {
    case violin, bass
    
    var values: (name: String, lineDelta: Int) /* delta Notenlinien */ {
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
//     --0--   <-- Linie 0

struct Note {
    var grundTon = Grundton.c
    var vorzeichen = Vorzeichen.ohne
    var oktave = Oktave.eingestrichene
    var notenschlüssel = Notenschlüssel.violin
    
    var line: Int {
        return grundTon.values.line + oktave.values.lineDelta + notenschlüssel.values.lineDelta
    }
    
    var describe: String {
        var name = oktave.values.upper
        ? 
        oktave.values.postPräfix + grundTon.values.name.uppercaseString
        :
        grundTon.values.name + oktave.values.postPräfix
        
        return "\(name) - \(notenschlüssel.values.name), Linie \(line)"
    }
}

var c = Note()

//c.oktave = .große
c.notenschlüssel = .bass
print(c.describe)








