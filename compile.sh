#!/bin/bash
set -eux

echo "Today is " `date -u --date=@1404372514`

cd ~

git clone --depth 1 https://git.eq2emu.com/devn00b/EQ2EMu.git

cd ~/EQ2EMu/EQ2/source/depends/recastnavigation/RecastDemo

curl -OL https://github.com/premake/premake-core/releases/download/v5.0.0-beta2/premake-5.0.0-beta2-linux.tar.gz

tar -xvf premake-5.0.0-beta2-linux.tar.gz

#Fix some issue with altStackMem size
sed -i -e 's/SIGSTKSZ/32768/g' ~/EQ2EMu/EQ2/source/depends/recastnavigation/Tests/catch.hpp

./premake5 gmake

cd Build/gmake

make

cd ../../../..

git clone https://github.com/fmtlib/fmt.git

cd ~/EQ2EMu/EQ2/source/LoginServer/

make -j$(nproc)

cd ~/EQ2EMu/EQ2/source/WorldServer

make -j$(nproc)

cd /workspace

cp ~/EQ2EMu/EQ2/source/WorldServer/eq2world ./ && cp ~/EQ2EMu/EQ2/source/LoginServer/login ./

cp -rT ~/EQ2EMu/server .

ls -ltra

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!!!!!!!!!Yay, it compiled and built!!!!!!!!!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
