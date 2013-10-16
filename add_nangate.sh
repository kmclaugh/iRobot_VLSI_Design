#!/bin/bash
# enviornment file for FreePDK (Nangate)
echo off
clear

# Remove any .cdslck file
find -name '*.cdslck' -print -exec rm {} \;


# Set the PDK_DIR variable to the root directory of the FreePDK distribution
export PDK_DIR=/opt/cadence/FreePDK45_1.4
export CDSHOME=/ad/eng/opt/cadence/IC614
export PYTHONPATH=$PYTHONPATH:$PDK_DIR/ncsu_basekit/techfile/cni
export MGC_CALIBRE_DRC_RUNSET_FILE=./.runset.calibre.drc
export MGC_CALIBRE_LVS_RUNSET_FILE=./.runset.calibre.lvs
export MGC_CALIBRE_PEX_RUNSET_FILE=./.runset.calibre.pex

# VAR FOR EXT 9.1, not used by Cadence, but a convientient place to define it
# path/bin is exported at the end of this file
export QRC_HOME=/ad/eng/opt/cadence/EXT91
# IC package install directory
export CDS=/ad/eng/opt/cadence/IC614
# use assura 4_614 > 3.17, trying to use the newest verisons
export ASSURAHOME=/ad/eng/opt/cadence/ASSURA4_614 
# MMSIM PACKAGE (7.2)
export MMSIM=/ad/eng/opt/cadence/MMSIM72
# EDI 9.1
export EDI=/opt/cadence/EDI91
# ModelSim 6.6
export VSIM=/opt/mentor/modelsim

# cadence license server
export CDS_LIC_FILE=5280@CadenceLM.bu.edu

# mentor graphics license server
export MGLS_LICENSE_FILE=1717@mentorlic1.bu.edu

# prevent assura from using LD_ASSUME_KERNEL
export NO_ASSUME_KERNEL=yes

# add the .cdsenv file from CWD, and save to the CWD
export CDS_LOAD_ENV=CWD

# everyone's locks should be local, so don't wait too long for clsbd
export CLS_CLSBD_CONNECT_TIMEOUT=5

# students don't want to learn vim
export EDITOR=gedit

# some helpful defaults
export CDS_Netlisting_Mode=Analog
export SKIP_CDS_DIALOG=t
export SPECTRE_DEFAULTS=-E
export CDS_LOG_PATH='.'

# export our PATHs
pathmunge () {
    if ! echo $PATH | /bin/egrep -q "(^|:)$1($|:)" ; then
    PATH=$PATH:$1
    fi
}

#define binaries for Cadence
pathmunge $CDS/tools/bin
pathmunge $CDS/tools/dfII/bin
# EXT 9.1 with QRC must be exported before ASSURA
pathmunge $QRC_HOME/bin

# define binaries for Assura
pathmunge $ASSURAHOME/tools/bin
pathmunge $ASSURAHOME/tools/assura/bin

# define binaries for MMSIM72
pathmunge $MMSIM/tools/bin
pathmunge $MMSIM/bin

# define binaries for EDI91
pathmunge $EDI/tools/bin

# define binaries for modelsim
pathmunge $VSIM/modeltech/bin

PATH=$PATH:/opt/cadence/IUS82/tools/verilog/bin:/opt/cadence/IUS82/tools/simvision/bin

export PATH

# Remove the "#" in the next line if you would like virtuoso to automatically start.
# virtuoso -64&
