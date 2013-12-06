use oocsiphash
include ./siphash_base

_le64toh: extern func (UInt64) -> UInt64
_SIPCONST1, _SIPCONST2, _SIPCONST3, _SIPCONST4: extern UInt64

//DOUBLE_ROUND: extern func (UInt64, UInt64, UInt64, UInt64)

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
            DOUBLE_ROUND(v0, v1, v2, v3)
            v0 ^= mi
        }

        t: UInt64 = 0
        pt := t& as UInt8*
        m := in as UInt8*

        // Unrolled duff's device :(
        match (srcSize) {
            case 7 =>
                pt[6] = m[6]
                pt[5] = m[5]
                pt[4] = m[4]
                (pt as UInt32*)@ = (m as UInt32*)@
            case 6 =>
                pt[5] = m[5]
                pt[4] = m[4]
                (pt as UInt32*)@ = (m as UInt32*)@
            case 5 =>
                pt[4] = m[4]
                (pt as UInt32*)@ = (m as UInt32*)@
            case 4 =>
                (pt as UInt32*)@ = (m as UInt32*)@
            case 3 =>
                pt[2] = m[2]
                pt[1] = m[1]
                pt[0] = m[0]
            case 2 =>
                pt[1] = m[1]
                pt[0] = m[0]
            case 1 =>
                pt[0] = m[0]
        }
        b |= _le64toh(t)

        v3 ^= b
        DOUBLE_ROUND(v0, v1, v2, v3)
        v0 ^= b; v2 ^= 0xff
        DOUBLE_ROUND(v0, v1, v2, v3)
        DOUBLE_ROUND(v0, v1, v2, v3)
        return (v0 ^ v1) ^ (v2 ^ v3)
    }
}

