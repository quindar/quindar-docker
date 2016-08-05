# Build NASA GMAT Instructions
Updated: Jul 18, 2016 by Masaki Kakoi

Step-by-step guide

    Login to the server and go to the directory where you want to build GMAT
    Download GMAT-src-R2015a-Mac-Linux-Bug-Fixes.tar.gz by typing the following commands:
        sudo wget "https://sourceforge.net/projects/gmat/files/GMAT/GMAT-R2015a/GMAT-src-R2015a-Mac-Linux-Bug-Fixes.tar.gz"
    Download GMAT-datafiles-R2015a.zip:
        sudo wget "https://sourceforge.net/projects/gmat/files/GMAT/GMAT-R2015a/GMAT-datafiles-R2015a.zip"
    Unzip both folders:
        sudo tar -xvzf GMAT-src-R2015a-Mac-Linux-Bug-Fixes.tar.gz
            This creates a folder GMAT-R2015a.
        sudo unzip GMAT-datafiles-R2015a.zip
            This creates a folder GMAT-datafiles-R2015a.
    Install necessary software packages:
        sudo yum groupinstall "Development Tools"
        sudo yum install csh
        sudo yum install gtk3-devel
        sudo yum install freeglut-devel
        sudo yum install python34
        sudo yum install python34-devel
        sudo yum install cmake
    Build dependencies:
        Go to depends folder under GMAT-R2015a
        Check if configure.sh is executable:
            ls -al
        If the file is not executable, change it to executable:
            sudo chmod ugo+x configure.sh
        Change line 159, from WX_$wx_version_download.tar.gz to v$wx_version.tar.gz
            sudo vim configure.sh to open the file using vim
            Type :159 to go to line 159
            Press i to change to the insert mode
            change WX_$wx_version_download.tar.gz to v$wx_version.tar.gz
            Press Esc to exit the insert mode
            Type :w to save
            Type :q to exit vim
        Execute the file:
            sudo ./configure.sh
    Run cmake
        Change directory to GMAT-R2015a:
            cd ..
        Run cmake with CMakeLists.txt
            sudo cmake CMakeLists.txt
    Correct errors.
        CMake fails to include dependency directory depends/cspice/linux/cspice64/include.
             cp depends/cspice/linux/cspice64/include/* src/base/util/ #copy the dependencies into the folder of the files which depend on them.
        Make expects depends/cspice/linux/cspice64/lib/cspice.a, but file is named cspiced.a
            cp depends/cspice/linux/cspice64/lib/cspiced.a depends/cspice/linux/cspice64/lib/cspice.a #makes a copy of cspiced.a named cspice.a
    Build GMAT:
        sudo make
    Move the data folder under application folder:
        Go to GMAT-datafiles-R2015a
        Copy the data folder under application folder:
            e.g. sudo cp -a data ../GMAT-R2015a/application/data
    Run GMAT
        Move to application/bin folder:
        Test if GMAT runs:
        e.g. sudo ./GmatConsole ../samples/Ex_Attitude_VNB.script
