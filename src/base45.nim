## A simple to use library to encode/decode using [base45](https://datatracker.ietf.org/doc/draft-faltstrom-base45/?include_text=1) encoding

import math
import sugar
import strutils
import strformat

type
    Base45Exception* = object of ValueError
    DecodeError* = ref object of Base45Exception
        pos*: int
        invalidChar*: char

const alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ $%*+-./:"

func divmod(x, y: SomeNumber): (SomeNumber, SomeNumber) =
    return (x div y, x mod y)

func b45encode*(source: string): string =
    ## Encodes a string into base45

    runnableExamples:
        assert b45encode("Hello World") == "%69 VD82EI2B.KEA2"

    for i in countup(0, (source.len and (not 1)) - 2, 2):
        let n = (source[i].uint shl 8) + source[i + 1].uint
        let (e, x) = divmod(n, 45 * 45)
        let (d, c) = divmod(x, 45)
        result &= alphabet[c] & alphabet[d] & alphabet[e]
    if (source.len and 1) != 0:
        let (d, c) = divmod(source[^1].uint, 45)
        result &= alphabet[c] & alphabet[d]


proc b45decode*(source: string): string =
    ## Decodes a base45 encoded string
    ##
    ## .. warning::  String must respect this condition: (len(string) mod 3) != 1

    runnableExamples:
        assert b45decode("%69 VD82EI2B.KEA2") == "Hello World"

    let s: seq[int] = collect:
        for c in source:
            alphabet.find(c)
    if s.len mod 3 == 1:
        raise DecodeError(msg: "String must respect this condition: (len(string) mod 3) != 1",
                pos: 0, invalidChar: ' ')
    for i in countup(0, s.len, 3):
        if s.len - i >= 3:
            let x = s[i] +
                s[i + 1] * 45 +
                s[i + 2] * 45 * 45
            if x > 0xFFFF:
                raise DecodeError(msg: &"Invalid character at pos:{i} ('{source[i]}')",
                        pos: i, invalidChar: source[i])
            result &= char(x div 256) & char(x mod 256)
        else:
            let x = s[i] +
                s[i + 1] * 45
            if x > 0xFF:
                raise new(DecodeError)
            result &= char(x)
