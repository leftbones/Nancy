# github.com/leftbones/nancy
# Nim + ANSI = Nancy

import os, terminal, strformat

type
    Key* {.pure.} = enum
        Escape = '\e'

type
    NancyError* = object of Exception

var code: string = "\x1b"
var nancyInitialized: bool = false

proc nancyStart(hide_cursor: bool = true) =
    if nancyInitialized:
        raise newException(NancyError, "Nancy already initialized")

    if hide_cursor:
        stdout.write code & "[?25l"

    stdout.write code & "[?1049h"
    nancyInitialized = true

proc nancyExit() =
    stdout.write code & "[?25h"
    stdout.write code & "[?1049l"

proc getKey(): char =
    return getch()

proc setCursor(x, y: Natural) =
    stdout.write fmt"{code}[{y};{x}H"


# TESTING
# =========================

nancyStart()

while true:
    var ch = getKey()
    case ch
    of 'q':
        break
    of Key.Escape:
        break
    else:
        setCursor(0, 0)
        stdout.write "Key: " & ch

nancyExit()