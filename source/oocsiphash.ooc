use oocsiphash
include ./siphash_base

_le64toh: extern func (UInt64) -> UInt64
_SIPCONST1, _SIPCONST2, _SIPCONST3, _SIPCONST4: extern UInt64

Sip: class {

    hash24: static func (src: Pointer, srcSize: ULong, key: Char*) -> UInt64 {
        _key := key as UInt64*
        k0 := _le64toh(_key[0])
        k1 := _le64toh(_key[1])
        b := (srcSize as UInt64) << (56 as UInt64)
        in := src as UInt64*

        v0 := k0 ^ _SIPCONST1
        v1 := k1 ^ _SIPCONST2
        v2 := k0 ^ _SIPCONST3
        v3 := k1 ^ _SIPCONST4

        while (srcSize >= 8) {
            mi := _le64toh(in@)
            in += 1; srcSize -= 8
            v3 ^= mi
            DOUBLE_ROUND(v0&, v1&, v2&, v3&)
            v0 ^= mi
        }

        t: UInt64 = 0

        // C code was using duff's device, let's bet on memcpy
        memcpy(t&, in, srcSize)
        b |= _le64toh(t)

        v3 ^= b
        DOUBLE_ROUND(v0&, v1&, v2&, v3&)
        v0 ^= b; v2 ^= 0xff
        DOUBLE_ROUND(v0&, v1&, v2&, v3&)
        DOUBLE_ROUND(v0&, v1&, v2&, v3&)
        return (v0 ^ v1) ^ (v2 ^ v3)
    }

    ROTATE: static func (x, b: UInt64) -> UInt64 {
        (x << b) | (x >> (64 as UInt64 - b))
    }

    HALF_ROUND: static func (a, b, c, d: UInt64@, s, t: UInt64) {
        a += b; c += d
        b = ROTATE(b, s) ^ a
        d = ROTATE(d, t) ^ c
        a = ROTATE(a, 32)
    }

    DOUBLE_ROUND: static func (v0, v1, v2, v3: UInt64@) {
        HALF_ROUND(v0&, v1&, v2&, v3&, 13, 16)
        HALF_ROUND(v2&, v1&, v0&, v3&, 17, 21)
        HALF_ROUND(v0&, v1&, v2&, v3&, 13, 16)
        HALF_ROUND(v2&, v1&, v0&, v3&, 17, 21)
    }
}

