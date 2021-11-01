# Base45

### With this library you can encode/decode strings using Base45 encoding

## Installation
```bash
$ nimble install https://github.com/DavideGalilei/base45
```

## Usage
```nim
import base45

let encoded = b45encode("Hello World")
let decoded = b45decode(encoded)
echo decoded # Hello World
```

## Run tests
```bash
$ nimble test
```

## Credits
This library is inspired from https://github.com/kirei/python-base45

## License
This project is under MIT license.
