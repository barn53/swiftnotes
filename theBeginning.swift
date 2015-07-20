enum IntervalModifier {
    case rein
    case groß
    case klein
    case übermäßig
    case doppeltÜbermäßig
    case vermindert
    case doppeltVermindert
    case tritonus

    var values: (name: String, semiTones: Int) {
        switch self {
            case rein:        return ("rein"      ,  0) // perfect
            case groß:        return ("groß"      ,  0) // major
            case klein:       return ("klein"     , -1) // minor
            case übermäßig:   return ("übermäßig" ,  1) // augmented
            case doppeltÜbermäßig: return ("doppelt übermäßig", 2)  // double augmented
            case vermindert:  return ("vermindert", -1) // -1 bei reinen, -2 bei großen Grundintervallen // dimished
            case doppeltVermindert: return ("doppelt vermindert", -2) // double dimished
            case tritonus:    return ("tritonus"  ,  1) // +1 bei Quarte, -1 bei Quinte // tritone
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
    
    var values: (name: String, lines: Int, semiTones: Int) {
        switch self {
            case Prim:     return ("Prim",   0, 0)   // unison
            case Second:   return ("Second", 1, 2)   // 2nd
            case Terz:     return ("Terz",   2, 4)   // 3rd
            case Quarte:   return ("Quarte", 3, 5)   // 4th
            case Quinte:   return ("Quinte", 4, 7)   // 5th
            case Sexte:    return ("Sexte",  5, 9)   // 6th
            case Septime:  return ("Septe",  6, 11)  // 7th
            case Oktave:   return ("Oktave", 7, 12)  // octave
        }
    }
}

// ♯ ♭

var matrix = [IntervalType : [IntervalModifier : (Int, Int?)]]()
//                                                ^    ^
//    delta of lines, delta of halftones (nil means illegal modifier for interval)
matrix[.Prim]     = [.rein: (0, 0  ), .groß: (0, nil), .klein: (0, nil), .übermäßig: (0, 1 ), .vermindert: (0, -1), .tritonus: (0, nil)]
matrix[.Second]   = [.rein: (1, nil), .groß: (1, 2  ), .klein: (1, 1  ), .übermäßig: (1, 3 ), .vermindert: (1, 0 ), .tritonus: (1, nil)]
matrix[.Terz]     = [.rein: (2, nil), .groß: (2, 4  ), .klein: (2, 3  ), .übermäßig: (2, 5 ), .vermindert: (2, 2 ), .tritonus: (2, nil)]
matrix[.Quarte]   = [.rein: (3, 5  ), .groß: (3, nil), .klein: (3, nil), .übermäßig: (3, 6 ), .vermindert: (3, 4 ), .tritonus: (3, 6  )]
matrix[.Quinte]   = [.rein: (4, 7  ), .groß: (4, nil), .klein: (4, nil), .übermäßig: (4, 8 ), .vermindert: (4, 6 ), .tritonus: (4, 6  )]
matrix[.Sexte]    = [.rein: (5, nil), .groß: (5, 9  ), .klein: (5, 8  ), .übermäßig: (5, 10), .vermindert: (5, 7 ), .tritonus: (5, nil)]
matrix[.Septime]  = [.rein: (6, nil), .groß: (6, 11 ), .klein: (6, 10 ), .übermäßig: (6, 12), .vermindert: (6, 9 ), .tritonus: (6, nil)]
matrix[.Oktave]   = [.rein: (7, 12 ), .groß: (7, nil), .klein: (7, nil), .übermäßig: (7, 13), .vermindert: (7, 11), .tritonus: (7, nil)]

struct Interval {
    var type = IntervalType.Prim
    var modifier = IntervalModifier.rein
    
    init(type: IntervalType, modifier: IntervalModifier) {
        self.type = type
        self.modifier = modifier

        checkTypeVsModifier()
    }
    
    func checkTypeVsModifier() -> Bool {
        var valid: Set<IntervalType>
        switch modifier {
            case .rein:       valid = [.Prim, .Quarte, .Quinte, .Oktave]
            case .groß:       valid = [.Second, .Terz,  .Sexte, .Septime]
            case .klein:      valid = [.Second, .Terz,  .Sexte, .Septime]
            case .übermäßig:  return true
            case .vermindert: valid = [.Second, .Terz, .Quarte, .Quinte, .Sexte, .Septime]
            case .tritonus:   valid = [.Quarte, .Quinte]
        }
        
        return valid.contains(type)
    }
    
    var lines: Int {
        return matrix[type]![modifier]!.0
    }
    
    var halfTones: Int {
        return matrix[type]![modifier]!.1!
    }
    
    var name: String {
        if modifier == .tritonus || halfTones == 6 {
            return "Tritonus"
        }
        return "\(type.name) \(modifier.name)"
    }
    
    var describe: String {
        return "\(name) (\(lines) , \(halfTones)) -> valid: \(checkTypeVsModifier())"
    }
}

var terz  = Interval(type: .Terz, modifier: .groß)
var tri   = Interval(type: .Quinte, modifier: .vermindert)
var tri2  = Interval(type: .Quarte, modifier: .übermäßig)

print("\(terz.describe)\n")
print("\(tri.describe)\n")
print("\(tri2.describe)\n")

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

