
############################################################ Makefile option
QUIET := true
ifeq "$(QUIET)" "true"
Q=@
else
Q=
endif

############################################################ Parasoft option
PARA := 0
CPPTEST_PROJ_NAME ?= tvos

############################################################ lint option
LINT := 0

############################################################ source files.
SRC      +=

############################################################ depnedent header files.
INCS     +=

############################################################ dependent libraries
LIBS     +=

############################################################ final target name
#BINNAME   :=
#SOLIBNAME :=

ifeq "$(BUILDTYPE)" "lib"
SOLIBNAME  = $(LIBNAME).so
ALIBNAME   = $(LIBNAME).a
endif

############################################################ loading software config
include $(MI_TOP)/project/sw_cfg/android_config.mk

############################################################ toolchain
include $(MI_TOP)/toolchain.mk

############################################################ build word wide option
BUILD_64BIT ?= no
BUILD_32BIT ?= yes

############################################################ release path

ifeq "$(FPU_ENABLE)" "1"
FLOATING_FOLDER = hard_float
else
FLOATING_FOLDER = soft_float
endif

SOLIB_REL_PATH ?= $(TARGET_DIRPATH)/dynamic
ALIB_REL_PATH ?= $(TARGET_DIRPATH)/static
BIN_REL_PATH ?= $(TARGET_DIRPATH)/binary
SOLIB_REL_PATH_64BIT ?= $(TARGET_DIRPATH)/dynamic_64
ALIB_REL_PATH_64BIT ?= $(TARGET_DIRPATH)/static_64
BIN_REL_PATH_64BIT ?= $(TARGET_DIRPATH)/binary_64

INC_REL_PATH ?=

############################################################ Tool related
ifeq "$(PARA)" "0"
CC       := $(GXX)
CC_64BIT   := $(GXX_64BIT)
else
CC       := cpptestscan --cpptestscanProjectName=$(CPPTEST_PROJ_NAME) $(GXX)
endif

############################################################ prepare target for makefile
LIBPATH  = ./lib.$(CHIP)
ifdef MKFILE
OBJPATH  = ./obj.$(CHIP)/$(MKFILE)/$(OBJNAME)
else #MKFILE
OBJPATH  = ./obj.$(CHIP)/$(OBJNAME)
endif
BINPATH  = ./bin.$(CHIP)
OBJ_CPP0   = $(filter %.o,$(notdir $(patsubst %.cpp, %.o,   $(SRC))))
OBJ_CPP    = $(foreach file, $(OBJ_CPP0),  $(OBJPATH)/$(file))
OBJ_C0   = $(filter %.o,$(notdir $(patsubst %.c, %.o,   $(SRC))))
OBJ_C    = $(foreach file, $(OBJ_C0),  $(OBJPATH)/$(file))
OBJ_S0   = $(filter %.o,$(notdir $(patsubst %.S, %.o,   $(SRC))))
OBJ_S    = $(foreach file, $(OBJ_S0),  $(OBJPATH)/$(file))
OBJ      = $(OBJ_C)
DEP_0    = $(filter %.d,$(notdir $(patsubst %.cpp, %.d, $(SRC))))
DEP_0    += $(filter %.d,$(notdir $(patsubst %.c, %.d, $(SRC))))
DEP      = $(foreach file, $(DEP_0), $(OBJPATH)/$(file))


LIBPATH_64BIT  = ./lib_64.$(CHIP)
ifdef MKFILE
OBJPATH_64BIT  = ./obj_64.$(CHIP)/$(MKFILE)/$(OBJNAME)
else #MKFILE
OBJPATH_64BIT  = ./obj_64.$(CHIP)/$(OBJNAME)
endif
BINPATH_64BIT  = ./bin_64.$(CHIP)
OBJ_CPP0_64BIT   = $(filter %.o,$(notdir $(patsubst %.cpp, %.o,   $(SRC))))
OBJ_CPP_64BIT    = $(foreach file, $(OBJ_CPP0_64BIT),  $(OBJPATH_64BIT)/$(file))
OBJ_C0_64BIT   = $(filter %.o,$(notdir $(patsubst %.c, %.o,   $(SRC))))
OBJ_C_64BIT    = $(foreach file, $(OBJ_C0_64BIT),  $(OBJPATH_64BIT)/$(file))
OBJ_S0_64BIT   = $(filter %.o,$(notdir $(patsubst %.S, %.o,   $(SRC))))
OBJ_S_64BIT    = $(foreach file, $(OBJ_S0_64BIT),  $(OBJPATH_64BIT)/$(file))
OBJ_64BIT      = $(OBJ_C_64BIT)
DEP_0_64BIT    = $(filter %.d,$(notdir $(patsubst %.cpp, %.d, $(SRC))))
DEP_0_64BIT    += $(filter %.d,$(notdir $(patsubst %.c, %.d, $(SRC))))
DEP_64BIT      = $(foreach file, $(DEP_0_64BIT), $(OBJPATH_64BIT)/$(file))


############################################################ flags for compiling.
CFLAGS += $(CC_OPTS)
CFLAGS += $(COMMOM_C_FLAGS)
CFLAGS += $(INCS)
CFLAGS += $(LOCAL_CFLAGS)
CPPFLAGS += $(COMMON_CPP_FLAGS)

ifeq ($(USE_OLD_COMPILE_VERSION),yes)
CPPFLAGS := $(filter-out -std=c++%, $(CPPFLAGS))
endif


CFLAGS_64BIT += $(CC_OPTS)
CFLAGS_64BIT += $(COMMOM_C_FLAGS_64BIT)
CFLAGS_64BIT += $(INCS)
CFLAGS_64BIT += $(LOCAL_CFLAGS)
CPPFLAGS_64BIT += $(COMMON_CPP_FLAGS_64BIT)

############################################################ flags for linking
LDFLAGS  += $(COMMON_LD_FLAGS)
LDFLAGS  += $(LIBS)

LDFLAGS_64BIT   += $(COMMON_LD_FLAGS_64BIT)
LDFLAGS_64BIT   += $(LIBS_64)


BIN_LDFLAGS  += -o $(BINPATH)/$(BINNAME)
SO_LDFLAGS += -shared -o $(LIBPATH)/$(SOLIBNAME)

BIN_LDFLAGS_64BIT  += -o $(BINPATH_64BIT)/$(BINNAME)
SO_LDFLAGS_64BIT += -shared -o $(LIBPATH_64BIT)/$(SOLIBNAME)


ifeq ($(SPECIAL_DYNAMIC_LINK),y)
    LINK_TYPE:=dynamic
    endif
    
    SOURCE_OBJ ?=./$(OBJPATH)/*.o
    
    SOURCE_OBJ_64BIT ?=./$(OBJPATH_64BIT)/*.o
    
    ############################################################ build all
    all: check_gccver ckbtype mkobjdir
    ifeq "$(LINK_TYPE)" "static"
    ifdef MKFILE
        $(Q)$(MAKE) -f $(MKFILE) $(BINNAME) $(ALIBNAME) genbdf lint
        else
            $(Q)$(MAKE) $(BINNAME) $(ALIBNAME) genbdf lint
            endif
            else #LINK_TYPE
            ifdef MKFILE
                $(Q)$(MAKE) -f $(MKFILE) $(BINNAME) $(SOLIBNAME) genbdf lint
                else
                    $(Q)$(MAKE) $(BINNAME) $(SOLIBNAME) genbdf lint
                    endif
                    endif #LINK_TYPE
                    

############################################################ build binary executable
ifeq "$(BUILDTYPE)" "bin"
$(BINNAME):
ifdef MKFILE
    $(Q) $(MAKE) -f $(MKFILE) $(BINPATH)/$(BINNAME)
    ifeq "$(BUILD_64BIT)" "yes"
        $(Q) $(MAKE) -f $(MKFILE) $(BINPATH_64BIT)/$(BINNAME)
        endif
        else #MKFILE
            $(Q) $(MAKE) $(BINPATH)/$(BINNAME)
            ifeq "$(BUILD_64BIT)" "yes"
                $(Q) $(MAKE) $(BINPATH_64BIT)/$(BINNAME)
                endif
                endif #MKFILE
                
                $(BINPATH)/$(BINNAME): $(OBJ_S) $(OBJ_C) $(OBJ_CPP) $(LOCAL_STATIC_LIBRARYS)
                ifneq ($(COMPILE_OBJ_ONLY),y)
                ifeq ($(LINK_BIN_ONLY),y)
                    $(Q) $(CC) -Wl,--start-group $(SPECIAL_OBJ) $(LOCAL_STATIC_LIBRARYS) -Wl,--end-group -fPIE -pie $(LDFLAGS) $(BIN_LDFLAGS)
                    else
                        $(Q) $(CC) -Wl,--start-group $(SOURCE_OBJ) $(LOCAL_STATIC_LIBRARYS)  -Wl,--end-group -fPIE $(LDFLAGS) $(BIN_LDFLAGS)
                        endif
                            @echo "[ executable : $(BINPATH)/$(BINNAME) Build succeed ]"
                            else
                                @echo "[ executable : compile to obj only, succeed ]"
                                endif
                                
                                $(BINPATH_64BIT)/$(BINNAME): $(OBJ_S_64BIT) $(OBJ_C_64BIT) $(OBJ_CPP_64BIT) $(LOCAL_STATIC_LIBRARYS_64BIT)
                                ifneq ($(COMPILE_OBJ_ONLY),y)
                                ifeq ($(LINK_BIN_ONLY),y)
                                    $(Q) $(CC_64BIT) -Wl,--start-group $(SPECIAL_OBJ_64BIT) $(LOCAL_STATIC_LIBRARYS_64BIT) -Wl,--end-group -fPIE -pie $(LDFLAGS_64BIT) $(BIN_LDFLAGS_64BIT)
                                    else
                                        $(Q) $(CC_64BIT) -Wl,--start-group $(SOURCE_OBJ_64BIT) $(LOCAL_STATIC_LIBRARYS_64BIT)  -Wl,--end-group -fPIE $(LDFLAGS_64BIT) $(BIN_LDFLAGS_64BIT)
                                        endif
                                            @echo "[ executable : $(BINPATH_64BIT)/$(BINNAME) Build succeed ]"
                                            else
                                                @echo "[ executable : compile to obj only, succeed ]"
                                                endif
                                                
                                                
                                                endif
                                                
                                                ############################################################ build shared library
                                                ifeq "$(BUILDTYPE)" "lib"
                                                $(SOLIBNAME):
                                                ifdef MKFILE
                                                    $(Q) $(MAKE) -f $(MKFILE) $(LIBPATH)/$(SOLIBNAME)
                                                    ifeq "$(BUILD_64BIT)" "yes"
                                                        $(Q) $(MAKE) -f $(MKFILE) $(LIBPATH_64BIT)/$(SOLIBNAME)
                                                        endif
                                                        else #MKFILE
                                                            $(Q) $(MAKE) $(LIBPATH)/$(SOLIBNAME)
                                                            ifeq "$(BUILD_64BIT)" "yes"
                                                                $(Q) $(MAKE) $(LIBPATH_64BIT)/$(SOLIBNAME)
                                                                endif
                                                                endif #MKFILE
                                                                
             $(ALIBNAME):
             ifdef MKFILE
                 $(Q) $(MAKE)  -f $(MKFILE) $(LIBPATH)/$(ALIBNAME)
                 ifeq "$(BUILD_64BIT)" "yes"
                     $(Q) $(MAKE) -f $(MKFILE) $(LIBPATH_64BIT)/$(ALIBNAME)
                     endif
                     else #MKFILE
                         $(Q) $(MAKE) $(LIBPATH)/$(ALIBNAME)
                         ifeq "$(BUILD_64BIT)" "yes"
                             $(Q) $(MAKE) $(LIBPATH_64BIT)/$(ALIBNAME)
                             endif
                             endif #MKFILE
                             
                             $(LIBPATH)/$(SOLIBNAME): $(OBJ_S) $(OBJ_C) $(OBJ_CPP)  $(LOCAL_STATIC_LIBRARYS)
                                 $(Q) $(CC) $(SO_LDFLAGS) -Wl,--start-group $(LDFLAGS) $(SOURCE_OBJ) -Wl,--end-group  -Wl,-soname,$(SOLIBNAME) $(LOCAL_STATIC_LIBRARYS)
                                     @echo "[ shared library : $(LIBPATH)/$(SOLIBNAME) Build succeed ]"
                                     $(LIBPATH)/$(ALIBNAME): $(OBJ_S) $(OBJ_C) $(OBJ_CPP) $(LOCAL_STATIC_LIBRARYS)
                                         $(Q) $(AR) sq $(LIBPATH)/$(ALIBNAME) $(SOURCE_OBJ)
                                             @echo "[ static library : $(LIBPATH)/$(ALIBNAME) Build succeed ]"
                                             
                                             $(LIBPATH_64BIT)/$(SOLIBNAME): $(OBJ_S_64BIT) $(OBJ_C_64BIT) $(OBJ_CPP_64BIT)  $(LOCAL_STATIC_LIBRARYS_64BIT)
                                                 $(Q) $(CC_64BIT) $(LDFLAGS_64BIT) $(SO_LDFLAGS_64BIT) -Wl,-soname,$(SOLIBNAME) $(SOURCE_OBJ_64BIT) $(LOCAL_STATIC_LIBRARYS_64BIT)
                                                     @echo "[ shared library : $(LIBPATH_64BIT)/$(SOLIBNAME) Build succeed ]"
                                                     $(LIBPATH_64BIT)/$(ALIBNAME): $(OBJ_S_64BIT) $(OBJ_C_64BIT) $(OBJ_CPP_64BIT) $(LOCAL_STATIC_LIBRARYS_64BIT)
                                                         $(Q) $(AR_64BIT) sq $(LIBPATH_64BIT)/$(ALIBNAME) $(SOURCE_OBJ_64BIT)
                                                             @echo "[ static library : $(LIBPATH_64BIT)/$(ALIBNAME) Build succeed ]"
                                                             
                                                             endif
                                                             
             
             ############################################################ Compile each source
             $(OBJ_S) :$(OBJPATH)/%.o : %.S
                 @echo ">> Compile $<"
                     $(Q) $(CC) $(INCS) $(CFLAGS) -MM $< | sed -e 's/\(.*\)\.o/\$$\(OBJPATH\)\/\1.o/g' > $(@:.o=.d)
                         $(Q) $(GCC) $(CFLAGS) -c -o $@ $<;
                         
                         $(OBJ_C) :$(OBJPATH)/%.o : %.c
                             @echo ">> Compile $<"
                                 $(Q) $(CC) $(INCS) $(CFLAGS) -MM $< | sed -e 's/\(.*\)\.o/\$$\(OBJPATH\)\/\1.o/g' > $(@:.o=.d)
                                     $(Q) $(GCC) $(CFLAGS) -c -o $@ $<;
                                     
                                     $(OBJ_CPP) : $(OBJPATH)/%.o : %.cpp
                                         @echo ">> Compile $<"
                                             $(Q) $(CC) $(INCS) $(CFLAGS) -MM $< | sed -e 's/\(.*\)\.o/\$$\(OBJPATH\)\/\1.o/g' > $(@:.o=.d)
                                                 $(Q) $(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<;
                                                 
                                                 $(OBJ_S_64BIT) :$(OBJPATH_64BIT)/%.o : %.S
                                                     @echo ">> Compile 64 $<"
                                                         $(Q) $(CC_64BIT) $(INCS) $(CFLAGS_64BIT) -MM $< | sed -e 's/\(.*\)\.o/\$$\(OBJPATH_64BIT\)\/\1.o/g' > $(@:.o=.d)
                                                             $(Q) $(GCC_64BIT) $(CFLAGS_64BIT) -c -o $@ $<;
                                                             
                                                             $(OBJ_C_64BIT) :$(OBJPATH_64BIT)/%.o : %.c
                                                                 @echo ">> Compile 64 $<"
                                                                     $(Q) $(CC_64BIT) $(INCS) $(CFLAGS_64BIT) -MM $< | sed -e 's/\(.*\)\.o/\$$\(OBJPATH_64BIT\)\/\1.o/g' > $(@:.o=.d)
                                                                         $(Q) $(GCC_64BIT) $(CFLAGS_64BIT) -c -o $@ $<;
                                                                         
                                                                         $(OBJ_CPP_64BIT) : $(OBJPATH_64BIT)/%.o : %.cpp
                                                                             @echo ">> Compile 64 $<"
                                                                                 $(Q) $(CC_64BIT) $(INCS) $(CFLAGS_64BIT) -MM $< | sed -e 's/\(.*\)\.o/\$$\(OBJPATH_64BIT\)\/\1.o/g' > $(@:.o=.d)
                                                                                     $(Q) $(CC_64BIT) $(CPPFLAGS_64BIT) $(CFLAGS_64BIT) -c -o $@ $<;
                                                                                     
                                                                                     
                                                                                     ############################################################ Prepare dir for obj.
                                                                                     mkobjdir:
                                                                                         $(Q)mkdir $(OBJPATH) -p
                                                                                         ifeq "$(BUILDTYPE)" "lib"
                                                                                             $(Q)mkdir $(LIBPATH) -p
                                                                                             endif
                                                                                             ifeq "$(BUILDTYPE)" "bin"
                                                                                                 $(Q)mkdir $(BINPATH) -p
                                                                                                 endif
                                                                                                 ifeq "$(BUILD_64BIT)" "yes"
                                                                                                     $(Q)mkdir $(OBJPATH_64BIT) -p
                                                                                                     ifeq "$(BUILDTYPE)" "lib"
                                                                                                         $(Q)mkdir $(LIBPATH_64BIT) -p
                                                                                                         endif
                                                                                                         ifeq "$(BUILDTYPE)" "bin"
                                                                                                             $(Q)mkdir $(BINPATH_64BIT) -p
                                                                                                             endif
                                                                                                             endif
                                                                                                             
                   ############################################################ check build type
                   ckbtype:
                   ifeq "$(BUILDTYPE)" "bin"
                       @echo "[Building executable..... $(BINNAME)]"
                       ifeq "$(BINNAME)" ""
                           @echo "please specify BINNAME = "
                               exit
                               endif
                               else
                               ifeq "$(BUILDTYPE)" "lib"
                                   @echo "[Building library.....$(LIBNAME)]"
                                   ifeq "$(LIBNAME)" ""
                                       @echo "please specify LIBNAME = "
                                           exit
                                           endif
                                           else
                                               @echo "please specify in Makefile BUILDTYPE = bin/lib"
                                                   exit
                                                   endif
                                                   endif
                                                   
                                                   
                                                   ############################################################ clean & build
                                                   rebuild: clean all release
                                                   
                                                   ############################################################ release to project env.
                                                   
                                                   official_release: clean
                                                       $(Q) $(MAKE) all
                                                           $(Q) $(MAKE) release
                                                           
                                                           release:
                                                           ifneq "$(REL_INCS)" ""
                                                           ifneq "$(INC_REL_PATH)" ""
                                                               $(Q) mkdir -p $(INC_REL_PATH)
                                                                   $(Q) cp -vrf $(REL_INCS) $(INC_REL_PATH)
                                                                   endif
                                                                   endif
                                                                   ifeq "$(BUILDTYPE)" "bin"
                                                                   ifneq ($(COMPILE_OBJ_ONLY),y)
                                                                       $(Q) mkdir -p $(BIN_REL_PATH)
                                                                           $(Q) cp -vf ./$(BINPATH)/$(BINNAME) $(BIN_REL_PATH)
                                                                           else
                                                                               $(Q) mkdir -p $(BIN_REL_PATH)/$(BINNAME)
                                                                                   $(Q) cp -vf ./$(OBJPATH)/*.o $(BIN_REL_PATH)/$(BINNAME)
                                                                                   endif
                                                                                   endif
                                                                                   ifeq "$(BUILDTYPE)" "lib"
                                                                                   ifeq "$(LINK_TYPE)" "static"
                                                                                       $(Q) cp -vf $(LIBPATH)/$(ALIBNAME) $(ALIB_REL_PATH)
                                                                                       else
                                                                                           $(Q) cp -vf $(LIBPATH)/$(SOLIBNAME) $(SOLIB_REL_PATH)
                                                                                           endif #LINK_TYPE
                                                                                           endif #BUILDTYPE
                   
                   ifeq "$(BUILD_64BIT)" "yes"
                   ifeq "$(BUILDTYPE)" "bin"
                   ifneq ($(COMPILE_OBJ_ONLY),y)
                       $(Q) mkdir -p $(BIN_REL_PATH_64BIT)
                           $(Q) cp -vf ./$(BINPATH_64BIT)/$(BINNAME) $(BIN_REL_PATH_64BIT)
                           else
                               $(Q) mkdir -p $(BIN_REL_PATH_64BIT)/$(BINNAME)
                                   $(Q) cp -vf ./$(OBJPATH_64BIT)/*.o $(BIN_REL_PATH_64BIT)/$(BINNAME)
                                   endif
                                   endif
                                   ifeq "$(BUILDTYPE)" "lib"
                                   ifeq "$(LINK_TYPE)" "static"
                                       $(Q) cp -vf $(LIBPATH_64BIT)/$(ALIBNAME) $(ALIB_REL_PATH_64BIT)
                                       else
                                           $(Q) cp -vf $(LIBPATH_64BIT)/$(SOLIBNAME) $(SOLIB_REL_PATH_64BIT)
                                           endif #LINK_TYPE
                                           endif #BUILDTYPE
                                           endif #BUILD_64BIT
                                           
                                           ############################################################ clean
                                           clean:
                                               $(Q) rm -rf ./obj.$(CHIP)
                                               ifeq "$(BUILDTYPE)" "bin"
                                                   $(Q) rm -rf ./$(BINPATH)
                                                       $(Q) rm -rf $(BIN_REL_PATH)/$(BINNAME)
                                                       endif
                                                       ifeq "$(BUILDTYPE)" "lib"
                                                           $(Q) rm -rf $(LIBPATH)
                                                           ifeq "$(LINK_TYPE)" "static"
                                                               $(Q) rm -rf $(ALIB_REL_PATH)/$(ALIBNAME)
                                                               else
                                                                   $(Q) rm -rf $(SOLIB_REL_PATH)/$(SOLIBNAME)
                                                                   endif #LINK_TYPE
                                                                   endif #BUILDTYPE
                                                                       $(Q) rm -rf ./*~
                                                                       ifeq ($(LINT),1)
                                                                           $(Q) find `pwd` -name "*.lnt" -exec rm -f {} \;
                                                                           endif
                                                                           ifeq "$(BUILD_64BIT)" "yes"
                                                                               $(Q) rm -rf ./obj_64.$(CHIP)
                                                                               ifeq "$(BUILDTYPE)" "bin"
                                                                                   $(Q) rm -rf ./$(BINPATH_64BIT)
                                                                                       $(Q) rm -rf $(BIN_REL_PATH_64BIT)/$(BINNAME)
                                                                                       endif
                                                                                       ifeq "$(BUILDTYPE)" "lib"
                                                                                           $(Q) rm -rf $(LIBPATH_64BIT)
                                                                                           ifeq "$(LINK_TYPE)" "static"
                                                                                               $(Q) rm -rf $(ALIB_REL_PATH_64BIT)/$(ALIBNAME)
                                                                                               else
                                                                                                   $(Q) rm -rf $(SOLIB_REL_PATH_64BIT)/$(SOLIBNAME)
                                                                                                   endif #LINK_TYPE
                                                                                                   endif #BUILDTYPE
                                                                                                   
                                                                                                   endif
                                                                                                   ############################################################ genbdf
                                                                                                   genbdf:
                                                                                                   ifeq "$(PARA)" "1"
                                                                                                       $(Q) mkdir -p $(PHOTOSPHERE_ROOT)/bdf_files
                                                                                                           $(Q) find -name "*.bdf" -exec cat {} >> $(PHOTOSPHERE_ROOT)/bdf_files/tvos.bdf \;
                                                                                                               $(Q) find -name "*.bdf" -exec rm {} \;
                                                                                                               endif
                                                                                                               
                                                                                                               ############################################################ dependency
                                                                                                               ifneq "$(MAKECMDGOALS)" "clean"
                                                                                                               -include $(DEP)
                                                                                                               endif
                                                                                                               ############################################################ lint
                                                                                                               LINT_INC=$(subst -I,,$(INCS))
                                                                                                               LINT_SRC_C=$(SRC)
                                                                                                               LINT_DEF=$(subst -D,-d,$(filter -D%,$(CFLAGS)))
                                                                                                               
                                                                                                               lint:
                                                                                                               ifeq ($(LINT),1)
                                                                                                                   $(Q) echo `pwd`
                                                                                                                       $(Q) find `pwd` -name "*.lnt" -exec rm {} \;
                                                                                                                           $(Q) (\
                                                                                                                               for i in $(LINT_DEF); do \
                                                                                                                                       echo $$i; \
                                                                                                                                           done; \
                                                                                                                                               ) >> define.lnt ;\
                                                                                                                                                   (\
                                                                                                                                                       for i in $(LINT_INC); do \
                                                                                                                                                               echo -i\"$$i\"; \
                                                                                                                                                                   done; \
                                                                                                                                                                       ) >> include.lnt;\
                                                                                                                                                                           (\
                                                                                                                                                                               for i in $(LINT_SRC_C); do \
                                                                                                                                                                                       echo $$i; \
                                                                                                                                                                                           done; \
                                                                                                                                                                                               ) >> source.lnt
                                                                                                                                                                                                   $(Q) sed -i "s?-i\"\.?-i\"$$PWD\/\.?g" include.lnt
                                                                                                                                                                                                       $(Q) sed -i "s?^?$$PWD\/?g" source.lnt
                                                                                                                                                                                                       endif
                                                                                                                                                                                                       
                                                                                                                                                                                                       # **********************************************
                                                                                                                                                                                                       # Check Toolchain rm .GCCver.log
                                                                                                                                                                                                       # **********************************************
                                                                                                                                                                                                       check_gccver:
                                                                                                                                                                                                           @($(GCC) -v 2>&1 | grep $(GCC_VERSION) > /dev/null) || ( echo "GCC version should be $(GCC_VERSION). please check it!!" ;exit 99)
