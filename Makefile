LIBNAME = input

PACKAGE_NAME = $(LIBNAME)lib.zip

ifeq ($(OS),Windows_NT)
	CP = xcopy /y /-y /s /e
	MV = move /y /-y
	RM = del /q /s
else
	CP = cp -rf
	MV = mv -f
	RM = rm -rf
endif

BUILD_DIR = ./build

RBXM_BUILD = $(LIBNAME)lib.rbxm

SOURCES =	src/WhileKeyPressed.luau	\
         	src/watchKey.luau	\
         	src/init.luau

TEST_SOURCES =	tests/watchKey.client.luau	\
              	tests/WhileKeyPressed.client.luau

$(BUILD_DIR): 
	mkdir $@

./Packages: wally.toml
	wally install
	


BUILD_SOURCES = $(addprefix $(BUILD_DIR)/, $(notdir $(SOURCES)))

$(BUILD_DIR)/wally.toml:	$(BUILD_DIR)	wally.toml
	$(CP) wally.toml build/

MV_SOURCES:	$(BUILD_DIR)	$(SOURCES)
	$(CP) src/* $(BUILD_DIR)

$(BUILD_SOURCES):	MV_SOURCES

# Build package
$(PACKAGE_NAME):	$(BUILD_SOURCES)	$(BUILD_DIR)/wally.toml
	wally package --output $(PACKAGE_NAME) --project-path $(BUILD_DIR)

# Full rebuild package
package:	clean-package	clean-build	$(PACKAGE_NAME)
	

publish: clean-build 	$(BUILD_SOURCES)
	wally publish --project-path $(BUILD_DIR)

lint:
	selene src/ tests/

# Build rbxm
$(RBXM_BUILD):	library.project.json	$(SOURCES)
	rojo build library.project.json --output $@

# Rebuild rxbm
rbxm: clean-rbxm $(RBXM_BUILD)

# Build tests
tests.rbxl:	./Packages	tests.project.json	$(SOURCES)	$(TEST_SOURCES)
	rojo build tests.project.json --output $@

# Rebuild tests
tests:	clean-tests	tests.rbxl

sourcemap.json:	./Packages	tests.project.json
	rojo sourcemap tests.project.json --output $@

# Re gen sourcemap
sourcemap:	clean-sourcemap	sourcemap.json


clean-sourcemap: 
	$(RM) sourcemap.json

clean-rbxm:
	$(RM) $(RBXM_BUILD)

clean-tests:
	$(RM) tests.rbxl

clean-build:
	$(RM) $(BUILD_DIR)

clean-package:
	$(RM) $(PACKAGE_NAME)

clean:	clean-tests	clean-build	clean-rbxm	clean-package	clean-sourcemap
