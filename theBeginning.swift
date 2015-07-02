enum IntervalModifier: String {
    case rein       = "rein"
    case groß       = "groß"
    case klein      = "klein"
    case übermäßig  = "übermäßig"
    case vermindert = "vermindert"
    case tritonus   = "tritonus"
    
    var name: String {
        return rawValue
    }
}

enum IntervalType: String {
    case Prim    = "Prim"
    case Second  = "Second"
    case Terz    = "Terz"
    case Quarte  = "Quarte"
    case Quinte  = "Quinte"
    case Sexte   = "Sexte"
    case Septime = "Septe"
    case Oktave  = "Oktave"
    
    var halfTone : Int {
        switch self {
            case .Prim: return 0
            case .Second: return 2
            case .Terz: return 4
            case .Quarte: return 5
            case .Quinte: return 7
            case .Sexte: return 9
            case .Septime: return 11
            case .Oktave: return 12
        }
    }
    var line : Int {
        switch self {
            case .Prim: return 0
            case .Second: return 1
            case .Terz: return 2
            case .Quarte: return 3
            case .Quinte: return 4
            case .Sexte: return 5
            case .Septime: return 6
            case .Oktave: return 7
        }
    }
    var name : String {
        return rawValue
    }
}

var matrix = [IntervalType : [IntervalModifier : (Int, Int?)]]()
//                                                ^    ^
//    Number of lines, number of halftones
matrix[.Prim]    = [.rein: (0, 0  ), .groß: (0, nil), .klein: (0, nil), .übermäßig: (0, 1 ), .vermindert: (0, -1), .tritonus: (0, nil)]
matrix[.Second]  = [.rein: (1, nil), .groß: (1, 2  ), .klein: (1, 1  ), .übermäßig: (1, 3 ), .vermindert: (1, 0 ), .tritonus: (1, nil)]
matrix[.Terz]    = [.rein: (2, nil), .groß: (2, 4  ), .klein: (2, 3  ), .übermäßig: (2, 5 ), .vermindert: (2, 2 ), .tritonus: (2, nil)]
matrix[.Quarte]  = [.rein: (3, 5  ), .groß: (3, nil), .klein: (3, nil), .übermäßig: (3, 6 ), .vermindert: (3, 4 ), .tritonus: (3, 6  )]
matrix[.Quinte]  = [.rein: (4, 7  ), .groß: (4, nil), .klein: (4, nil), .übermäßig: (4, 8 ), .vermindert: (4, 6 ), .tritonus: (4, 6  )]
matrix[.Sexte]   = [.rein: (5, nil), .groß: (5, 9  ), .klein: (5, 8  ), .übermäßig: (5, 10), .vermindert: (5, 7 ), .tritonus: (5, nil)]
matrix[.Septime] = [.rein: (6, nil), .groß: (6, 11 ), .klein: (6, 10 ), .übermäßig: (6, 12), .vermindert: (6, 9 ), .tritonus: (6, nil)]
matrix[.Oktave]  = [.rein: (7, 12 ), .groß: (7, nil), .klein: (7, nil), .übermäßig: (7, 13), .vermindert: (7, 11), .tritonus: (7, nil)]

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
            case .vermindert: valid = [.Second, .Terz,  .Sexte, .Septime]
            case .tritonus:   valid = [.Quarte, .Quinte]
        }
        
        return valid.contains(type)
    }
    
    var lines: Int {
        return type.line
    }
    
    var halfTones: Int {
        return 1
    }
    
    var name: String {
        return "\(type.name) \(modifier.name)"
    }
}


var terz = Interval(type: .Terz, modifier: .vermindert)

print("\(terz.name) -> valid: \(terz.checkTypeVsModifier())\n")



