enum IntervalModifier {
    case rein
    case groß
    case klein
    case übermäßig
    case doppeltÜbermäßig
    case vermindert
    case doppeltVermindert
    case tritonus

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
    case Prim
    case Second
    case Terz
    case Quarte
    case Quinte
    case Sexte
    case Septime
    case Oktave
    
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
                else {
                    st = 0 // invalid modifier validate must have returned false
                }
            case .tritonus:
                if (type == .Quarte) {
                    st = type.values.semitones + 1
                }
                else if (type == .Quinte) {
                    st = type.values.semitones - 1
                }
                else {
                    st = 0 // invalid modifier validate must have returned false
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

print("\(terz.describe)\n")
print("\(tri.describe)\n")
print("\(tri2.describe)\n")
print("\(tri3.describe)\n")
print("\(tri4.describe)\n")
print("\(tri5.describe)\n")


/*******************************************************************/
enum Grundton {
    case c
    case d
    case e

    var data: (name: String, line: Int, semitones: Int) {
        switch self {
            case c:
                return ("c", 0, 0)
            case d:
                return ("d", 1, 2)
            case e:
                return ("e", 2, 4)
        }
    }
}

var t = Grundton.d
println(t.data)
println(t.data.0)
println(t.data.name)
