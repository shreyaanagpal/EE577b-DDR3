#/bin/csh
#
#################################################################
#Edited 09/17/2003 by Wai Hong Ho, added an alias for hspice
# to bypass a bug in get_arch which returns wrong os version
#
#Edited 07/17/2003 by Wai Hong Ho, added check to LD_LIBRARY_PATH
# Also changed HSPICE setup to use default version.
#
#Edited 08/29/2004 by Kyongsu Lee, modified env. paths for cadence &
# HSPICE.
#
#Edited 08/30/2004 by Peter A. Beerel, modified path for HSPICE
# to get around bug in get_arch which returned os version for which path
# to hspice does not exist. 
#
#Edited 06/26/2006 by Pankaj Golani, pointed the cadence setup file
#tothe newest cadence version as well as new license servers
#
#Edited 03/01/2007 by T.J. Kwon, modified path for latest
# DesignCompiler, NanoSim, PrimeTime, HSPICE
#
#Edited 02/01/2010 by Jeff Draper, modified path for Cadence
# setup
#
#Edited 03/10/2010 by Ko-Chung Tseng, added path for Cadence
#Conformal Logic Equivalence Checking
#################################################################

if ($?MANPATH) then
  setenv MANPATH ~ee577/cad/man:${MANPATH}
else
  setenv MANPATH ~ee577/cad/man:/usr/man:/usr/local/man
endif

setenv CAD_HOME ~ee577/cad

set path=($CAD_HOME/bin  $path )

################################################################

alias magic '~ee577/cad/bin/magic -d X11 -T SCN5M_SUBM_15_TSMC'
alias irsim '~ee577/cad/bin/irsim tsmc25.15.n99y.2.5.prm'
#alias mpla 'mpla -a -s pseudoCMOStemp -t ~ee577/cad/lib/mpla/p'

## Some handy path alias
alias prepend 'if (-d \!:2) if ("$\!:1" \!~ *"\!:2"*) setenv \!:1 "\!:2":${\!:1}'
alias extend  'if (-d \!:2) if ("$\!:1" \!~ *"\!:2"*) setenv \!:1 ${\!:1}:\!:2'


###############################################################
# License setup for Cadence tools
# Licesne server - 1800@license.usc.edu
# The License server used for Synopsys tools was changed to 
# 1900@license.usc.edu from 1800@license.usc.edu on Aug 12, 2010
# This file was modified by Ehsan on Aug 14 to reflect that change
###############################################################
if (  ${?LM_LICENSE_FILE} ) then
   echo ${LM_LICENSE_FILE} | grep 1800@license.usc.edu >& /dev/null
   if ( $status != 0  ) then
      setenv LM_LICENSE_FILE 1800@license.usc.edu:$LM_LICENSE_FILE
   endif
else
   setenv LM_LICENSE_FILE 1800@license.usc.edu
endif


###############################################################
# License setup for Synopsys tools
# Licesne server - 1900@license.usc.edu
# The License server used for Synopsys tools was changed to 
# 1900@license.usc.edu from 1800@license.usc.edu on Aug 12, 2010
# This file was modified by Ehsan on Aug 14 to reflect that change
###############################################################
if (  ${?LM_LICENSE_FILE} ) then
   echo ${LM_LICENSE_FILE} | grep 1900@license.usc.edu >& /dev/null
   if ( $status != 0  ) then
      setenv LM_LICENSE_FILE 1900@license.usc.edu:$LM_LICENSE_FILE
   endif
else
   setenv LM_LICENSE_FILE 1900@license.usc.edu
endif


#################################################################
## Cadence Tools
## Last modified by: Soowang Park
## Last modifed date: 08/31/2016
#################################################################

setenv CDSBASE /usr/local/cadence/

if ( "$HOST" == "viterbi-scf1.usc.edu" ) then

	setenv CDS_INST_DIR $CDSBASE/IC615
	setenv CADENCE_IC $CDSBASE/IC615        # Virtuoso
	setenv CADENCE_IF $CDSBASE/IFV82        # Incisive
	setenv CADENCE_MM $CDSBASE/MMSIM71      # 
	setenv CADENCE_CF $CDSBASE/CONFRML111   # Conformal
	setenv CADENCE_AS $CDSBASE/ASSURA41     # ASSURA
	setenv CADENCE_SO $CDSBASE/SOC81        # Encounter
	setenv CADENCE_DN $CDSBASE/VIPCAT113    # Denali
	

	## prepend PATH for binaries

	prepend PATH $CADENCE_IC/bin
	prepend PATH $CADENCE_IC/tools/bin
	prepend PATH $CADENCE_IC/tools/dfII/bin
	prepend PATH $CADENCE_IC/tools/dfII/pvt/bin

	prepend PATH $CADENCE_IF/tools/bin

	prepend PATH $CADENCE_MM/bin
	prepend PATH $CADENCE_MM/tools/bin
	prepend PATH $CADENCE_MM/tools/dfII/bin

	prepend PATH $CADENCE_CF/bin

	prepend PATH $CADENCE_AS/tools/bin
	prepend PATH $CADENCE_AS/tools/assura/bin

	prepend PATH $CADENCE_SO/tools/bin

	prepend PATH $CADENCE_DN/tools/denali/


	## prepend LD_LIBRARY_PATH

	if ( $?LD_LIBRARY_PATH ) then # if exists then prepend
		prepend LD_LIBRARY_PATH $CADENCE_IC/tools/lib
	else
		setenv  LD_LIBRARY_PATH $CADENCE_IC/tools/lib
	endif
	
	prepend LD_LIBRARY_PATH $CADENCE_IF/tools/lib

	prepend LD_LIBRARY_PATH $CADENCE_MM/tools/lib

	prepend LD_LIBRARY_PATH $CADENCE_CF/tools/lib

	prepend LD_LIBRARY_PATH $CADENCE_AS/tools/lib
	prepend LD_LIBRARY_PATH $CADENCE_AS/tools/assura/lib

	prepend LD_LIBRARY_PATH $CADENCE_SO/tools/lib


	## use analog mode for netlisting
	setenv CDS_Netlisting_Mode Analog
	
	## Denali
	setenv DENALI /usr/local/cadence/VIPCAT113/tools/denali

	## alias
	alias encounter $CADENCE_SO/tools/bin/velocity -edsxl
	alias velocity  $CADENCE_SO/tools/bin/velocity -edsxl

endif

if ( "$HOST" == "viterbi-scf2.usc.edu" ) then

	setenv CDS_INST_DIR $CDSBASE/IC617      # used later in cds.lib
	setenv CADENCE_IC $CDSBASE/IC617        # Virtuoso
	setenv CADENCE_IN $CDSBASE/INCISIVE152  # Incisive
	setenv CADENCE_MM $CDSBASE/MMSIM151     # 
	setenv CADENCE_CF $CDSBASE/CONFRML161   # Conformal
	setenv CADENCE_AS $CDSBASE/ASSURA41     # ASSURA
	setenv CADENCE_ED $CDSBASE/EDI142       # Encounter
	

	## prepend PATH for binaries

	prepend PATH $CADENCE_IC/bin
	prepend PATH $CADENCE_IC/tools/bin
	prepend PATH $CADENCE_IC/tools/dfII/bin

	prepend PATH $CADENCE_IN/bin
	prepend PATH $CADENCE_IN/tools/bin
	prepend PATH $CADENCE_IN/tools/dfII/bin

	prepend PATH $CADENCE_MM/tools/bin
	prepend PATH $CADENCE_MM/tools/DFII/bin

	prepend PATH $CADENCE_CF/bin
	prepend PATH $CADENCE_CF/tools/bin

	prepend PATH $CADENCE_AS/tools/bin
	prepend PATH $CADENCE_AS/tools/assura/bin

	#prepend PATH $CADENCE_ED/bin
	prepend PATH $CADENCE_ED/tools/bin


	## prepend LD_LIBRARY_PATH

	if ( $?LD_LIBRARY_PATH ) then # if exists then prepend
		prepend LD_LIBRARY_PATH $CADENCE_IC/tools/lib
	else
		setenv  LD_LIBRARY_PATH $CADENCE_IC/tools/lib
	endif
	
	prepend LD_LIBRARY_PATH $CADENCE_IN/lib
	prepend LD_LIBRARY_PATH $CADENCE_IN/tools/lib

	prepend LD_LIBRARY_PATH $CADENCE_MM/tools/lib

	prepend LD_LIBRARY_PATH $CADENCE_CF/tools/lib

	prepend LD_LIBRARY_PATH $CADENCE_AS/tools/lib
	prepend LD_LIBRARY_PATH $CADENCE_AS/tools/assura/lib

	prepend LD_LIBRARY_PATH $CADENCE_ED/tools/lib
	prepend LD_LIBRARY_PATH $CADENCE_ED/tools/lib/64bit
	prepend LD_LIBRARY_PATH $CADENCE_ED/tools/fe/lib/64bit
	prepend LD_LIBRARY_PATH $CADENCE_ED/oa_v22.50.011/lib/linux_rhel50_gcc44x_64/opt

	## alias
	alias encounter $CADENCE_ED/tools/bin/encounter

endif


##################################################################
## For use with XWin for Magic and Cadence tools
##################################################################
umask 022

if (${?LD_LIBRARY_PATH}) then

if ($?OPENWINHOME) then
  setenv LD_LIBRARY_PATH /usr/lib/X11:$OPENWINHOME/lib:/usr/lib:$LD_LIBRARY_PATH
else
  setenv LD_LIBRARY_PATH /usr/lib/X11:/usr/lib:$LD_LIBRARY_PATH
endif

else

if ($?OPENWINHOME) then
  setenv LD_LIBRARY_PATH /usr/lib/X11:$OPENWINHOME/lib:/usr/lib
else
  setenv LD_LIBRARY_PATH /usr/lib/X11:/usr/lib
endif

endif

#################################################################
## Synopsys HSPICE 2011.09 setup
#################################################################

######### HSPICE Global environment variable Thu Feb 22 11:59:59 PDT 2007 #########
## Using FLEXlm license file

## HSPICE 2011.09 works at viterbi-scf1.usc.edu by Soowang Park, Aug 29 2016 ####### 
if ( "$HOST" == "viterbi-scf1.usc.edu" ) then
	setenv SYNOPSYS_HS /usr/local/synopsys/2011.09/hspice

	unsetenv LANG
	unsetenv LC_ALL

	setenv ARCH      `$SYNOPSYS_HS/bin/get_arch -q`
	setenv HSP_HOME   $SYNOPSYS_HS
	set path = ( $HSP_HOME/$ARCH \
				 $HSP_HOME/bin \
				 $HSP_HOME/$ARCH/veriloga_utils/veriloga/include \
				 $path )
	######### End of Global section ##########

	prepend MANPATH $SYNOPSYS_HS/docs

	#alias hspice $SYNOPSYS_HS/sparcOS5/hspice
	alias mwaves $SYNOPSYS_HS/sparcOS5/awaves -laf motif
	alias awaves $SYNOPSYS_HS/sparcOS5/awaves -laf motif
endif


###############################################################
## Synopsys Tools setup
###############################################################
## Updated by Soowang Park, Aug 31 2016 #

setenv SYNBASE /usr/local/synopsys/


## 1. viterbi-scf1 server

if ( "$HOST" == "viterbi-scf1.usc.edu" ) then

	setenv SYNOPSYS_HS $SYNBASE/2011.09/hspice    # HSPICE	
	setenv SYNOPSYS_DC $SYNBASE/2011.09           # Design Compiler
	setenv SYNOPSYS_PT $SYNBASE/primetime_suite   # PrimeTime
	setenv SYNOPSYS_NS $SYNBASE/2011.09/nanosim   # NanoSim
	setenv SYNOPSYS_TM $SYNBASE/2011.09/tetramax  # TETRAMAX

	## prepend PATH for binaries

	prepend PATH $SYNOPSYS_HS/bin
	prepend PATH $SYNOPSYS_DC/bin
	prepend PATH $SYNOPSYS_PT/bin
	prepend PATH $SYNOPSYS_NS/bin
	prepend PATH $SYNOPSYS_TM/bin
endif


## 2. viterbi-scf2 server

if ( "$HOST" == "viterbi-scf2.usc.edu" ) then
	## HSPICE
	setenv SYNOPSYS_HS      $SYNBASE/HSPICE/default/hspice
	setenv SYNOPSYS_DC      $SYNBASE/Design_Compiler/default	
	setenv SYNOPSYS_PT      $SYNBASE/PrimeTime/default
	setenv SYNOPSYS_CS      $SYNBASE/CosmosScope/default
	setenv SYNOPSYS_WV	    $SYNBASE/Custom_Waveview/default
	setenv SYNOPSYS_DFT	    $SYNBASE/DFT_Compiler/default
	setenv SYNOPSYS_TM      $SYNBASE/TetraMAX/default/TetraMAX_Standalone
	setenv SYNOPSYS_VCS14   $SYNBASE/VCS_2014/default
	setenv SYNOPSYS_VCS16   $SYNBASE/VCS_2016/default

	prepend PATH $SYNOPSYS_HS/bin
	prepend PATH $SYNOPSYS_DC/bin
	prepend PATH $SYNOPSYS_PT/bin
	prepend PATH $SYNOPSYS_CS/bin
	prepend PATH $SYNOPSYS_WV/bin
	prepend PATH $SYNOPSYS_DFT/bin
	prepend PATH $SYNOPSYS_TM/bin
	prepend PATH $SYNOPSYS_VCS14/bin
	prepend PATH $SYNOPSYS_VCS14/bin

	## alias
	alias cscope $SYNOPSYS_CS/ai_bin/cscope
	alias scope  $SYNOPSYS_CS/ai_bin/scope
	alias dft_dc_shell   $SYNOPSYS_DFT/bin/dc_shell
	alias dft_dc_shell-t $SYNOPSYS_DFT/bin/dc_shell-t
	alias vcs    $SYNOPSYS_VCS16/bin/vcs

endif ## END of 2. viterbi-scf2 server


## Reference: old style example
## HSPICE
#setenv SYNOPSYS_HS      $SYNBASE/2011.09/hspice
#if ( "$PATH" !~ *":${SYNOPSYS_HS}/bin"* ) then
#	    set path = ( $path ${SYNOPSYS_HS}/bin )
#endif
#setenv MANPATH $SYNOPSYS_HS/doc/syn/man:$MANPATH


################################################################
#setenv FSDB_ENV_NOVAS_LOCK on
# or
setenv FSDB_ENV_SYNC_CONTROL off


#################################################################
## Setting environment variable for NCSU design kit
#################################################################
setenv CDK_DIR  /home/scf-22/ee577/design_pdk/ncsu-cdk-1.6.0.beta

