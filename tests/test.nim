from ../src/base45 import b45encode, b45decode

let encoded = b45encode("Hello World")
echo "Encoded: ", encoded # "%69 VD82EI2B.KEA2"
let decoded = b45decode(encoded)
echo "Decoded: ", decoded # "Hello World"
