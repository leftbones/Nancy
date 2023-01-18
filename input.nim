# Nancy - input.nim
# github.com/leftbones/nancy
#
# References:
# https://github.com/johnnovak/illwill/blob/master/illwill.nim
# https://github.com/genotrance/snip/blob/master/src/snip/key.nim

when defined(windows):
  proc getch(): char {.header: "<conio.h>", importc: "getch".}
  proc kbhit(): int {.header: "<conio.h>", importc: "kbhit".}
else:
  {.compile: "getch.c".}

  proc enable_raw_mode() {.importc.}
  proc disable_raw_mode() {.importc.}
  proc getch(): char {.importc.}
  proc kbhit(): int {.importc.}

  proc cleanExit*() =
    disable_raw_mode()

proc readKey*(): seq[int] {.inline.} =
  result = @[]
  when not defined(windows):
    enable_raw_mode()

  var
    lchr: char
    code: int

  while kbhit() != 0:
    lchr = getch()
    if lchr.int < 32 or lchr.int > 127:
      code = lchr.int
      if lchr.int in [0, 27, 224]:
        while kbhit() != 0:
          lchr = getch()
          result.add(lchr.int)
          # code = lchr.int
      result.insert(code, 0)
    else:
      result.add(lchr.int)

  when not defined(windows):
    disable_raw_mode()

type
  Key* {.pure.} = enum      ## Supported single key presses and key combinations
    None = (-1, "None"),

    # Special ASCII characters
    CtrlA       = (1, "CtrlA"),
    CtrlB       = (2, "CtrlB"),
    CtrlC       = (3, "CtrlC"),
    CtrlD       = (4, "CtrlD"),
    CtrlE       = (5, "CtrlE"),
    CtrlF       = (6, "CtrlF"),
    CtrlG       = (7, "CtrlG"),     # Same as ctrl+h
    Backspace   = (8, "Backspace"),
    Tab         = (9, "Tab"),       # Same as ctrl+i
    CtrlJ       = (10, "CtrlJ"),
    CtrlK       = (11, "CtrlK"),
    CtrlL       = (12, "CtrlL"),
    Enter       = (13, "Enter"),    # Same as ctrl+m
    CtrlN       = (14, "CtrlN"),
    CtrlO       = (15, "CtrlO"),
    CtrlP       = (16, "CtrlP"),
    CtrlQ       = (17, "CtrlQ"),
    CtrlR       = (18, "CtrlR"),
    CtrlS       = (19, "CtrlS"),
    CtrlT       = (20, "CtrlT"),
    CtrlU       = (21, "CtrlU"),
    CtrlV       = (22, "CtrlV"),
    CtrlW       = (23, "CtrlW"),
    CtrlX       = (24, "CtrlX"),
    CtrlY       = (25, "CtrlY"),
    CtrlZ       = (26, "CtrlZ"),
    Escape      = (27, "Escape"),

    CtrlBackslash    = (28, "CtrlBackslash"),
    CtrlRightBracket = (29, "CtrlRightBracket"),

    # Printable ASCII characters
    Space           = (32, "Space"),
    ExclamationMark = (33, "ExclamationMark"),
    DoubleQuote     = (34, "DoubleQuote"),
    Hash            = (35, "Hash"),
    Dollar          = (36, "Dollar"),
    Percent         = (37, "Percent"),
    Ampersand       = (38, "Ampersand"),
    SingleQuote     = (39, "SingleQuote"),
    LeftParen       = (40, "LeftParen"),
    RightParen      = (41, "RightParen"),
    Asterisk        = (42, "Asterisk"),
    Plus            = (43, "Plus"),
    Comma           = (44, "Comma"),
    Minus           = (45, "Minus"),
    Dot             = (46, "Dot"),
    Slash           = (47, "Slash"),

    Zero  = (48, "Zero"),
    One   = (49, "One"),
    Two   = (50, "Two"),
    Three = (51, "Three"),
    Four  = (52, "Four"),
    Five  = (53, "Five"),
    Six   = (54, "Six"),
    Seven = (55, "Seven"),
    Eight = (56, "Eight"),
    Nine  = (57, "Nine"),

    Colon        = (58, "Colon"),
    Semicolon    = (59, "Semicolon"),
    LessThan     = (60, "LessThan"),
    Equals       = (61, "Equals"),
    GreaterThan  = (62, "GreaterThan"),
    QuestionMark = (63, "QuestionMark"),
    At           = (64, "At"),

    ShiftA  = (65, "ShiftA"),
    ShiftB  = (66, "ShiftB"),
    ShiftC  = (67, "ShiftC"),
    ShiftD  = (68, "ShiftD"),
    ShiftE  = (69, "ShiftE"),
    ShiftF  = (70, "ShiftF"),
    ShiftG  = (71, "ShiftG"),
    ShiftH  = (72, "ShiftH"),
    ShiftI  = (73, "ShiftI"),
    ShiftJ  = (74, "ShiftJ"),
    ShiftK  = (75, "ShiftK"),
    ShiftL  = (76, "ShiftL"),
    ShiftM  = (77, "ShiftM"),
    ShiftN  = (78, "ShiftN"),
    ShiftO  = (79, "ShiftO"),
    ShiftP  = (80, "ShiftP"),
    ShiftQ  = (81, "ShiftQ"),
    ShiftR  = (82, "ShiftR"),
    ShiftS  = (83, "ShiftS"),
    ShiftT  = (84, "ShiftT"),
    ShiftU  = (85, "ShiftU"),
    ShiftV  = (86, "ShiftV"),
    ShiftW  = (87, "ShiftW"),
    ShiftX  = (88, "ShiftX"),
    ShiftY  = (89, "ShiftY"),
    ShiftZ  = (90, "ShiftZ"),

    LeftBracket  = (91, "LeftBracket"),
    Backslash    = (92, "Backslash"),
    RightBracket = (93, "RightBracket"),
    Caret        = (94, "Caret"),
    Underscore   = (95, "Underscore"),
    GraveAccent  = (96, "GraveAccent"),

    A = (97, "A"),
    B = (98, "B"),
    C = (99, "C"),
    D = (100, "D"),
    E = (101, "E"),
    F = (102, "F"),
    G = (103, "G"),
    H = (104, "H"),
    I = (105, "I"),
    J = (106, "J"),
    K = (107, "K"),
    L = (108, "L"),
    M = (109, "M"),
    N = (110, "N"),
    O = (111, "O"),
    P = (112, "P"),
    Q = (113, "Q"),
    R = (114, "R"),
    S = (115, "S"),
    T = (116, "T"),
    U = (117, "U"),
    V = (118, "V"),
    W = (119, "W"),
    X = (120, "X"),
    Y = (121, "Y"),
    Z = (122, "Z"),

    LeftBrace  = (123, "LeftBrace"),
    Pipe       = (124, "Pipe"),
    RightBrace = (125, "RightBrace"),
    Tilde      = (126, "Tilde"),
    # Backspace  = (127, "Backspace"), # Unused?

    # Special characters with virtual keycodes
    Up       = (1001, "Up"),
    Down     = (1002, "Down"),
    Right    = (1003, "Right"),
    Left     = (1004, "Left"),
    Home     = (1005, "Home"),
    Insert   = (1006, "Insert"),
    Delete   = (1007, "Delete"),
    End      = (1008, "End"),
    PageUp   = (1009, "PageUp"),
    PageDown = (1010, "PageDown"),

    F1  = (1011, "F1"),
    F2  = (1012, "F2"),
    F3  = (1013, "F3"),
    F4  = (1014, "F4"),
    F5  = (1015, "F5"),
    F6  = (1016, "F6"),
    F7  = (1017, "F7"),
    F8  = (1018, "F8"),
    F9  = (1019, "F9"),
    F10 = (1020, "F10"),
    F11 = (1021, "F11"),
    F12 = (1022, "F12"),

proc toKey(k: int): Key =
    try:
        result = Key(k)
    except RangeDefect:
        result = Key.None

proc getKey*(): Key =
    var k = readKey()
    var key = Key.None

    if k.len == 2:
        if k[0] == 0:
            case k[1]:
                of 59: key = Key.F1
                of 60: key = Key.F2
                of 61: key = Key.F3
                of 62: key = Key.F4
                of 63: key = Key.F5
                of 64: key = Key.F6
                of 65: key = Key.F7
                of 66: key = Key.F8
                of 67: key = Key.F9
                of 68: key = Key.F10
                else: discard
        elif k[0] == 224:
            case k[1]:
                of 72: key = Key.Up
                of 75: key = Key.Left
                of 77: key = Key.Right
                of 80: key = Key.Down
                
                of 71: key = Key.Home
                of 82: key = Key.Insert
                of 83: key = Key.Delete
                of 79: key = Key.End
                of 73: key = Key.PageUp
                of 81: key = Key.PageDown

                of 133: key = Key.F11
                of 134: key = Key.F12
                else: discard
    else:
        try:
            key = toKey(k[0])
        except IndexDefect, RangeDefect:
            discard
    return key