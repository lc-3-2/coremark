#File : core_portme.mak

# Flag : OUTFLAG
#	Use this flag to define how to to get an executable (e.g -o)
OUTFLAG= -o
# Flag : CC
#	Use this flag to define compiler to use
CC 		= clang
# Flag : LD
#	Use this flag to define compiler to use
LD		= clang
# Flag : AS
#	Use this flag to define compiler to use
AS		= llvm-mc
# Flag : CFLAGS
#	Use this flag to define compiler options. Note, you can add compiler options from the command line using XCFLAGS="other flags"
PORT_CFLAGS = \
	--target=lc_3.2-unknown-none -g -O2 \
	-ffunction-sections -fdata-sections \
	-mllvm -lc_3.2-max-repeated-ops=3 \
	-mllvm -lc_3.2-use-r4 -mllvm -lc_3.2-use-r7 \
	-mllvm -verify-machineinstrs
FLAGS_STR = "$(PORT_CFLAGS) $(XCFLAGS) $(XLFLAGS) $(LFLAGS_END)"
CFLAGS = $(PORT_CFLAGS) -I$(PORT_DIR) -I. -DFLAGS_STR=\"$(FLAGS_STR)\"
#Flag : LFLAGS_END
#	Define any libraries needed for linking or other flags that should come at the end of the link line (e.g. linker scripts).
#	Note : On certain platforms, the default clock_gettime implementation is supported but requires linking of librt.
LFLAGS_END = -T$(PORT_DIR)/ldscript
# Flag : SEPARATE_COMPILE
# You must also define below how to create an object file, and how to link.
SEPARATE_COMPILE=1

OBJOUT 	= -o
LFLAGS 	= --target=lc_3.2-unknown-none -nostdlib -Wl,--gc-sections
ASFLAGS = --arch=lc-3.2 --filetype=obj
OFLAG 	= -o
COUT 	= -c

PORT_CFILES = \
	$(PORT_DIR)/core_portme \
	$(PORT_DIR)/ee_printf
PORT_SFILES = \
	$(PORT_DIR)/startup
PORT_SRCS = $(addsuffix .c, $(PORT_CFILES)) $(addsuffix .s, $(PORT_SFILES))
PORT_OBJS = $(addprefix $(OPATH), $(addsuffix $(OEXT), $(PORT_CFILES) $(PORT_SFILES)))
vpath %.c $(PORT_DIR)
vpath %.s $(PORT_DIR)

# Flag : LOAD
#	For a simple port, we assume self hosted compile and run, no load needed.
LOAD = echo "Please set LOAD to the process of loading the executable to the flash"
# Flag : RUN
#	For a simple port, we assume self hosted compile and run, simple invocation of the executable
RUN = echo "Please set RUN to the process of running the executable (e.g. via jtag, or board reset)"

OEXT = .o
EXE = .elf

$(OPATH)$(PORT_DIR)/%$(OEXT) : %.c
	$(CC) $(CFLAGS) $(XCFLAGS) $(COUT) $< $(OBJOUT) $@

$(OPATH)%$(OEXT) : %.c
	$(CC) $(CFLAGS) $(XCFLAGS) $(COUT) $< $(OBJOUT) $@

$(OPATH)$(PORT_DIR)/%$(OEXT) : %.s
	$(AS) $(ASFLAGS) $< $(OBJOUT) $@

# Target : port_pre% and port_post%
# For the purpose of this simple port, no pre or post steps needed.

.PHONY : port_prebuild port_postbuild port_prerun port_postrun port_preload port_postload
port_pre% port_post% :

# FLAG : OPATH
# Path to the output folder. Default - current folder.
OPATH = ./
MKDIR = mkdir -p
