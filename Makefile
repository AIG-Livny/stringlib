TARGET		=	libstringlib.a
SOURCES		=   c-utils/src/stringlib.c
OBJ_PATH	?=  obj
CC			=   gcc
CFLAGS		?=	-O3
ARFLAGS 	=	rcs

LIBS_URLS	+=	https://github.com/barrust/c-utils.git

###

OBJECTS=$(SOURCES:%.c=$(OBJ_PATH)/%.o)
LIB_DIRS = $(foreach url,$(LIBS_URLS),$(shell basename $(url) .git))
DEPS=$(OBJECTS:.o=.d)
DEPFLAGS=-MMD -MP

$(foreach url,$(LIBS_URLS),$(eval URL_$(shell basename $(url) .git) := $(url)))

.PHONY: all clean cleanall

all: $(LIB_DIRS) $(TARGET)

clean:
	rm -rf $(OBJ_PATH) $(LIB_DIRS)

cleanall: clean
	rm -rf $(TARGET)

$(LIB_DIRS):
	$(if $(wildcard ../$@), ln -s ../$@ $@, git clone $(URL_$@) $@ 	)
	$(MAKE)

$(TARGET): $(OBJECTS)
	$(AR) $(ARFLAGS) $@ $(OBJECTS)

$(OBJ_PATH)/%.o: %.c Makefile
	mkdir -p $(dir $@)
	$(CC) $(DEPFLAGS) $(CFLAGS) -c $< -o $@

-include $(DEPS)