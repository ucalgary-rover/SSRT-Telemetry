# SSRTelemetry
Qt application built for sensor visual interface with processing capabilities.

## Running Linux build

### First install essential build tools for Qt Development

#### On Ubuntu
Install make and other build tools like gcc:
```bash
sudo apt install build-essential.
sudo apt install cmake.
```

### Building and Running on Qt Creator
The base application can be run in Qt Creator GUI simply by opening the CMakelists.txt file witin the project folder. Qt Creator may or may not need to be configured to detect build tool executables. For some systems it may auto detect the bin executables (make, cmake etc.) for you.

### Building and running manually with CMake
Will require a version of CMake (A cross platform build system that creates makefiles), make (Compiles and builds C/C++ files) and GNU Build tools.

The typical way to build manually is by first creating a directory in the project folder itself. Run ```mkdir build```.

Change directory to the build
```bash
cd build
```

Run CMake
```bash
cmake ...
```
This will create the build in the build folder and use the CMakeLists.txt found in the parent directory.

Then run make to compile:
```bash
make
```

The application can be run with
```bash
./appSSRTelemetry
```

## Before contributing
Precommit runs basic formatters and linters to enforce code formatting standards.

### Setting Up Pre-Commit
To ensure consistent code quality and enforce standards, we use **pre-commit** hooks. Follow the steps below to install and verify it:

### Installation

#### On Windows
Install pre-commit using pip:
```bash
pip install pre-commit
```

#### On Ubuntu Linux
Install pre-commit using pip:
```bash
sudo apt install python3-pip
pip3 install pre-commit
```

#### On Arch Linux
Install pre-commit using pip:
```bash
sudo pacman -S pre-commit
```

### Verification

After installation, verify the installation by checking the version:
```bash
pre-commit --version
```

Update if needed:
```bash
pre-commit autoupdate
```

If you see the expected version, pre-commit is successfully installed and ready to use!

### Linters and Static Analyzers
This repo uses basic language agnostic cleanup tools provided by pre-commit, clang-format to enforce LLVM code standard and cpp check to detect small bugs in C++ code.

You only need to install clang-format and cpp check.

### Installing clang-format
#### Ubuntu
```bash
sudo apt-install clang-format
```

### Installing cppcheck
#### Ubuntu
```bash
sudo apt install cppcheck
```

### Testing precommit
To test precommit execution run:
```bash
pre-commit run --all-files
```
If your code passes all tests then it is commit ready!

## Writing documentation the Doxygen way for C++
See resources for guidelines to writing documentation that is doxygen compatible

## Running Doxygen build manually

### Install Doxygen
Doxygen simplifies code documentation process

#### On Windows
Visit doxygen download page https://www.doxygen.nl/download.html

#### On Arch Linux
Install Doxygen using the package manager:
```bash
sudo pacman -S doxygen
```

#### On Ubuntu
Install Doxygen using apt:
```bash
sudo apt update
sudo apt install doxygen
```

### Generate documentation
Generate documentation manually
```bash
doxygen Doxyfile
```
