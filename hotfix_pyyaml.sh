#!/bin/bash -e
#
#
#echo "$0 $*"
echo "PYTHON_BIN=$PYTHON_BIN"
echo "PYTHONPATH=$PYTHONPATH"

PIP="./venv/bin/${PYTHON_BIN} -m pip"
echo "PIP=$PIP"

#export PYTHONPATH=""

#PYTHONPATH= ./venv/bin/$(PYTHON_BIN) -m pip install

##
## Last working build reported:
##
## Successfully installed XlsxWriter-3.0.9 altgraph-0.17.3 black-22.3.0 click-8.1.5 cmake-3.26.4 flake8-4.0.1
##   flake8-no-implicit-concat-0.3.3 install-1.3.5 mccabe-0.6.1 mypy-extensions-1.0.0 pathspec-0.11.1
##   platformdirs-3.9.1 pycodestyle-2.8.0 pyflakes-2.4.0 pyinstaller-5.13.0 pyinstaller-hooks-contrib-2023.5
##   pyyaml-5.4.1 tomli-2.0.1 wheel-0.40.0
##

$PIP install "Cython<3.0" "wheel==0.40.0" "pyinstaller==5.13.0" "pyinstaller-hooks-contrib==2023.5" "install==1.3.5" "setuptools" --no-build-isolation
$PIP install "mccabe==0.6.1" "mypy-extensions==1.0.0" "pathspec==0.11.1" "platformdirs==3.9.1" "tomli==2.0.1" --no-build-isolation
$PIP install "XlsxWriter==3.0.9" "altgraph==0.17.3" "black==22.3.0" "click==8.1.5" "cmake==3.26.4" --no-build-isolation
$PIP install "flake8==4.0.1" "flake8-no-implicit-concat==0.3.3" "pycodestyle==2.8.0" "pyflakes==2.4.0" --no-build-isolation

$PIP install "pyyaml<6" --no-build-isolation

# Lets see if we can just insert this above pyyaml
#(echo "Cython<3.0"; cat ./dependencies/python/run_time.txt) > ./dependencies/python/run_time.txt.n
#mv -f ./dependencies/python/run_time.txt.n ./dependencies/python/run_time.txt

