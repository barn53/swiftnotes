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
