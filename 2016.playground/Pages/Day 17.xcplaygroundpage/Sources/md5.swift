import Foundation

public func MD5(_ string: String) -> String
{
    var dataString = string.data(using: .utf8)!
    let originDataLengthBits = UInt64(dataString.count * 8)

    let byte1 = Data(repeating: UInt8(0x80), count : 1)
    let byte0 = Data(repeating: UInt8(0x00), count : 1)
    
    dataString.append(byte1)
    
    while ((dataString.count * 8) % 512 != 448) {
        dataString.append(byte0)
    }
    
    dataString.append(Data(bytes: addUint8Arr(int64: originDataLengthBits)))
    
    var TnArr : [UInt32] = Array(repeating: UInt32(0), count: 65)
    for x in 1...64 { TnArr[x] = Tn(x) }
    
    let numberOf512bitBlocks : Int = (dataString.count * 8) / 512
    
    var A : UInt32 = 0x67452301
    var B : UInt32 = 0xEFCDAB89
    var C : UInt32 = 0x98BADCFE
    var D : UInt32 = 0x10325476
    
    for block in 0 ..< numberOf512bitBlocks {
        var F64 = Array<UInt32>(repeating: 0, count: 16)
        
        for subblock in 0..<16 {
            let startIdx = dataString.startIndex + block*64 + subblock*4
            
            let f1 = UInt32(dataString[startIdx + 0])
            let f2 = UInt32(dataString[startIdx + 1])
            let f3 = UInt32(dataString[startIdx + 2])
            let f4 = UInt32(dataString[startIdx + 3])
            
            F64[subblock] =
                (f4 << 24) |
                (f3 << 16) |
                (f2 << 8)  |
                (f1 << 0)
        }
        let AA = A, BB = B, CC = C, DD = D
        
        // 3_1
        guide(&A, B, C, D, F64[ 0], 7 , TnArr[ 1] , funF)
        guide(&D, A, B, C, F64[ 1], 12, TnArr[  2], funF)
        guide(&C, D, A, B, F64[ 2], 17, TnArr[  3], funF)
        guide(&B, C, D, A, F64[ 3], 22, TnArr[  4], funF)
        guide(&A, B, C, D, F64[ 4], 7 , TnArr[ 5] , funF)
        guide(&D, A, B, C, F64[ 5], 12, TnArr[  6], funF)
        guide(&C, D, A, B, F64[ 6], 17, TnArr[  7], funF)
        guide(&B, C, D, A, F64[ 7], 22, TnArr[  8], funF)
        guide(&A, B, C, D, F64[ 8], 7 , TnArr[ 9] , funF)
        guide(&D, A, B, C, F64[ 9], 12, TnArr[ 10], funF)
        guide(&C, D, A, B, F64[10], 17, TnArr[ 11], funF)
        guide(&B, C, D, A, F64[11], 22, TnArr[ 12], funF)
        guide(&A, B, C, D, F64[12], 7 , TnArr[13] , funF)
        guide(&D, A, B, C, F64[13], 12, TnArr[ 14], funF)
        guide(&C, D, A, B, F64[14], 17, TnArr[ 15], funF)
        guide(&B, C, D, A, F64[15], 22, TnArr[ 16], funF)
        // 3_2
        guide(&A, B, C, D, F64[ 1], 5 , TnArr[17] , funG)
        guide(&D, A, B, C, F64[ 6], 9 , TnArr[18] , funG)
        guide(&C, D, A, B, F64[11], 14, TnArr[ 19], funG)
        guide(&B, C, D, A, F64[ 0], 20, TnArr[ 20], funG)
        guide(&A, B, C, D, F64[ 5], 5 , TnArr[21] , funG)
        guide(&D, A, B, C, F64[10], 9 , TnArr[22] , funG)
        guide(&C, D, A, B, F64[15], 14, TnArr[ 23], funG)
        guide(&B, C, D, A, F64[ 4], 20, TnArr[ 24], funG)
        guide(&A, B, C, D, F64[ 9], 5 , TnArr[25] , funG)
        guide(&D, A, B, C, F64[14], 9 , TnArr[26] , funG)
        guide(&C, D, A, B, F64[ 3], 14, TnArr[ 27], funG)
        guide(&B, C, D, A, F64[ 8], 20, TnArr[ 28], funG)
        guide(&A, B, C, D, F64[13], 5 , TnArr[29] , funG)
        guide(&D, A, B, C, F64[ 2], 9 , TnArr[30] , funG)
        guide(&C, D, A, B, F64[ 7], 14, TnArr[ 31], funG)
        guide(&B, C, D, A, F64[12], 20, TnArr[ 32], funG)
        // 3_3
        guide(&A, B, C, D, F64[ 5], 4 , TnArr[33] , funH)
        guide(&D, A, B, C, F64[ 8], 11, TnArr[ 34], funH)
        guide(&C, D, A, B, F64[11], 16, TnArr[ 35], funH)
        guide(&B, C, D, A, F64[14], 23, TnArr[ 36], funH)
        guide(&A, B, C, D, F64[ 1], 4 , TnArr[37] , funH)
        guide(&D, A, B, C, F64[ 4], 11, TnArr[ 38], funH)
        guide(&C, D, A, B, F64[ 7], 16, TnArr[ 39], funH)
        guide(&B, C, D, A, F64[10], 23, TnArr[ 40], funH)
        guide(&A, B, C, D, F64[13], 4 , TnArr[41] , funH)
        guide(&D, A, B, C, F64[ 0], 11, TnArr[ 42], funH)
        guide(&C, D, A, B, F64[ 3], 16, TnArr[ 43], funH)
        guide(&B, C, D, A, F64[ 6], 23, TnArr[ 44], funH)
        guide(&A, B, C, D, F64[ 9], 4 , TnArr[45] , funH)
        guide(&D, A, B, C, F64[12], 11, TnArr[ 46], funH)
        guide(&C, D, A, B, F64[15], 16, TnArr[ 47], funH)
        guide(&B, C, D, A, F64[ 2], 23, TnArr[ 48], funH)
        // 3_4
        guide(&A, B, C, D, F64[ 0], 6 , TnArr[49] , funI)
        guide(&D, A, B, C, F64[ 7], 10, TnArr[ 50], funI)
        guide(&C, D, A, B, F64[14], 15, TnArr[ 51], funI)
        guide(&B, C, D, A, F64[ 5], 21, TnArr[ 52], funI)
        guide(&A, B, C, D, F64[12], 6 , TnArr[53] , funI)
        guide(&D, A, B, C, F64[ 3], 10, TnArr[ 54], funI)
        guide(&C, D, A, B, F64[10], 15, TnArr[ 55], funI)
        guide(&B, C, D, A, F64[ 1], 21, TnArr[ 56], funI)
        guide(&A, B, C, D, F64[ 8], 6 , TnArr[57] , funI)
        guide(&D, A, B, C, F64[15], 10, TnArr[ 58], funI)
        guide(&C, D, A, B, F64[ 6], 15, TnArr[ 59], funI)
        guide(&B, C, D, A, F64[13], 21, TnArr[ 60], funI)
        guide(&A, B, C, D, F64[ 4], 6 , TnArr[61] , funI)
        guide(&D, A, B, C, F64[11], 10, TnArr[ 62], funI)
        guide(&C, D, A, B, F64[ 2], 15, TnArr[ 63], funI)
        guide(&B, C, D, A, F64[ 9], 21, TnArr[ 64], funI)
        
        A = AA &+ A
        B = BB &+ B
        C = CC &+ C
        D = DD &+ D
    }
    
    let md5_hash = uint32ToHexStr(A) + uint32ToHexStr(B) + uint32ToHexStr(C) + uint32ToHexStr(D)
    return md5_hash.lowercased()
}

func addUint8Arr(int64 : UInt64) -> [UInt8]
{
    return [
        UInt8(( int64 >> 0 ) & 0xFF),
        UInt8(( int64 >> 8 ) & 0xFF),
        UInt8(( int64 >> 16 ) & 0xFF),
        UInt8(( int64 >> 24 ) & 0xFF),
        UInt8(( int64 >> 32 ) & 0xFF),
        UInt8(( int64 >> 40 ) & 0xFF),
        UInt8(( int64 >> 48 ) & 0xFF),
        UInt8(( int64 >> 56 ) & 0xFF)
    ]
}

func uint32ToHexStr(_ ui : UInt32) -> String {
    let FF : UInt32 = 0xFF
    
    let f1 : UInt8 = UInt8(FF & ui)
    let f2 : UInt8 = UInt8(FF & (ui >> 8))
    let f3 : UInt8 = UInt8(FF & (ui >> 16))
    let f4 : UInt8 = UInt8(FF & (ui >> 24))
    
    let f1s = String(f1, radix: 16, uppercase: true)
    let f2s = String(f2, radix: 16, uppercase: true)
    let f3s = String(f3, radix: 16, uppercase: true)
    let f4s = String(f4, radix: 16, uppercase: true)
    
    return add0Sym(f1s) + add0Sym(f2s) + add0Sym(f3s) + add0Sym(f4s)
}

func add0Sym(_ str: String) -> String {
    if str.characters.count == 1 { return "0" + str }
    return str
}

func funF(_ x : UInt32, _ y : UInt32, _ z : UInt32 ) -> UInt32 {
    return (x & y) | ((~x) & z)
}

func funG(_ x : UInt32, _ y : UInt32, _ z : UInt32 ) -> UInt32 {
    return (x & z) | ((~z) & y)
}

func funH(_ x : UInt32, _ y : UInt32, _ z : UInt32 ) -> UInt32 {
    return x ^ y ^ z
}

func funI(_ x : UInt32, _ y : UInt32, _ z : UInt32 ) -> UInt32 {
    return y ^ ((~z) | x)
}

func Tn (_ n : Int) -> UInt32 {
    return UInt32(pow(2, 32) * abs(sin(Double(n))))
}

func guide (_ a : inout UInt32,
            _ b : UInt32,
            _ c : UInt32,
            _ d : UInt32,
            _ xk: UInt32,
            _ s : UInt32,
            _ ti: UInt32,
            _ fun : (UInt32, UInt32, UInt32 ) -> UInt32 )
{
    a = b &+ circRotateLeft(a &+ fun(b, c, d) &+ xk &+ ti,  by: s)
}

func circRotateLeft(_ x: UInt32, by: UInt32) -> UInt32 {
    return ((x << by) & 0xFFFFFFFF) | (x >> (32 - by))
}
