
/*******************************************************************/

// ♯ ♭




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
- zu einem Intervall alle möglichen Modifier bestimmen

- Akkord aus drei oder vier Noten bestimmen
- Folgenoten aus Grund-Note und Akkord

- Note (von Tonart) nach Tonart modulieren - geht das so?

- Tonleiter-Noten aus Grund-Note und Tonleiter erzeugen
- Tonleiter aus Noten bestimmen
- Paralleltonleiter bestimmen
- Folgetonleiter bestimmen

*/











