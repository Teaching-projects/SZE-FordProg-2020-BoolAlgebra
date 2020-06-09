# Boole algebra számítás Flex és bison segítségével

A szoftver képes boole függvény megoldására. 1-gyel jelöljük az igaz, 0-val a hamis értéket.

Fel tudunk venni és törölni tudunk változókat (x1-től x99-ig).

x1-hez hozzárendeljük 1 értéket:
```
x1 = 1
```
Többszöri hozzárendelés esetén felülírjuk a korábbi értéket.

x1 változó törlése:
```
delete x1
```
Változók kilistázása:
```
list
```

Ismert operátorok:
```
vagy: |
és: &
nem: -
implikáció: ->
ekvivalencia: <->
A fentiek mellett értelmezett a zárójelezés is.
```
A 'solve' paranccsal megoldhatunk egy adott függvényt. Ha nem ismert egy változó, akkor hibaüzenetet kapunk.
```
solve <függvény>
```
Példák függvényekre:
```
x1 | x2
x1 & x2 | x3
x1 & (x2 -> x3)
```
Mintakód:
```
x1 = 1
x2 = 0
x3 = 1
x4 = 1
delete x3
solve x1 <-> x2 & x4
solve x1 -> x4 | x1 & x2
solve x1 -> x3
```

Elvileg csak C-beli parancsokat használtam, tehát gcc-nek le kell fordítania.

Fordítás:
```
bison -d grammar.y
flex tokens.l
gcc grammar.tab.c lex.yy.c
```
