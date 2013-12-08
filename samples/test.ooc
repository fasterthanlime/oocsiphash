use oocsiphash
import oocsiphash

main: func {
    key: Char* = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0xa, 0xb, 0xc, 0xd, 0xe, 0xf ]

    {
        pt := "hello world!"
        hash := Sip hash24(pt, key)
        "plaintext=%s hash=%llu" printfln(pt, hash)
    }

    {
        a := (1, 2) as Vec2
        hash := Sip hash24(a, key)
        "hash=%llu" printfln(hash)
    }
}

Vec2: cover {
    a,b : Int
}

