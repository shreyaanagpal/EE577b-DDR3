#
# $Header: /src/common/usc/skel/RCS/dot.cshrc,v 1.5 1994/06/20 20:48:05 ucs Exp $
#

#
# If this is not an interactive shell, then we exit here.
#
if (! $?prompt) then
	exit 0
endif

#
# RC Revision Date
#
set rcRevDate=930824

#
# Set User Level of expertise.
#
set UserLevel=novice

###############################################################################
#
# Source a global .cshrc file.  
#
# DO NOT DELETE THIS SECTION!
#
# If you wish to customize your own environment, then add things AFTER
# this section.  In this way, you may override certain default settings,
# but still receive the system defaults.
#
if (-r /usr/lsd/conf/master.cshrc) then
	source /usr/lsd/conf/master.cshrc
else if (-r /usr/local/lib/master.cshrc) then
	source /usr/local/lib/master.cshrc
endif
###############################################################################

#
# Put your changes/additions, here.
#

#source ~ee577/setup.IC6
source ~/vlsi_tools_v3_beta.csh


## Environment Variables for NC-Verilog on "aludra.usc.edu"
if ( "$HOST" == "aludra.usc.edu" ) then
	setenv  CADENCE_IFV_ALUDRA  /usr/usc/cadence/default/IFV8.2
	prepend PATH                $CADENCE_IFV_ALUDRA/tools/bin
	prepend LD_LIBRARY_PATH     $CADENCE_IFV_ALUDRA/tools/lib
endif

setenv CDK_DIR /home/scf-22/ee577/design_pdk/ncsu-cdk-1.6.0.beta
setenv CDS_Netlisting_Mode Analog
# source /usr/usc/denali/7.2/setup.csh
# setenv HSP_HDL_PATH /usr/local/synopsys/2011.09/hspice/include

