Simple pure Swift AI Agent library that allows talking to models and exposing tools.
Implemented as full Swift 6 structured concurrecy to work on MacOS, iOS and Linux platforms.

## Project Structure
All new classes/structs/enums put in appropriate folder in separate file. Do not create long files with multiple definitions inside. Although you can add type's extensions in the same file as extended type. If you need extend some object to protocol, name file ObjectType+ProtocolName.swift.

## Building project
- Run `swift build` to build the project on local MacOS
- Run `docker run --rm -t  -v "$PWD":/workspace -w /workspace swift:6.1  swift build` to build the project in linux Swift 6.1
Remember to clean build folder (`rm -rf .build`) when building for different platform.

## Change commit
Never commit anything, let user review changes.
