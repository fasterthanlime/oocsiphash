use oocsiphash
import oocsiphash

main: func {
    key := [
        '\x00',
        '\x01',
        '\x02',
        '\x03',
        '\x04',
        '\x05',
        '\x06',
        '\x07',
        '\x08',
        '\x09',
        '\x0a',
        '\x0b',
        '\x0c',
        '\x0d',
        '\x0e',
        '\x0f'
    ] as Char*

    pt := "hello world!"
    hash := Sip hash24(pt toCString(), pt size, key)
    res := "%llu" cformat(hash)
    "plaintext=#{pt} hash=#{res}" println()
}

