use oocsiphash
import oocsiphash

main: func {
    key: Char* = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0xa, 0xb, 0xc, 0xd, 0xe, 0xf ]

    pt := "hello world!"
    hash := Sip hash24(pt toCString(), pt size, key)
    res := "%llu" cformat(hash)
    "plaintext=#{pt} hash=#{res}" println()
}

