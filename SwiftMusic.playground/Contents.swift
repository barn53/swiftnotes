
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


print("------------------------")
print(c.describe)
print(a.describe)
print(C.describe)
print(f.describe)
print(Fis.describe)

print("------------------------")
var i = Interval.determineFromNote(f, note2: a)
print(i!.name)

print("------------------------")
i = Interval.determineFromNote(Fis, note2: c)
print(i!.name)

print("------------------------")
i = Interval.determineFromNote(Fis, note2: C)
print(i!.name)

print("------------------------")
i = Interval.determineFromNote(c, note2: C)
print(i!.name)

var A = Note()
A.grundTon = .a
A.oktave = .klein
var aisis = Note()
aisis.grundTon = .a
aisis.vorzeichen = .doppelKreuz
print("------------------------")
i = Interval.determineFromNote(A, note2: aisis)
print(i!.name)


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


var d = Note()
var fis = Note()

d.grundTon = .d

fis.grundTon = .f
fis.vorzeichen = .kreuz

print(d.describe)
print(fis.describe)




/*

Was will ich berechnen können?

- Note(n) parsen: c#' d'' D eb'

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











