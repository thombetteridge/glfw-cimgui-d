
# --- d target
TARGET = main
DC = dmd
DCFLAGS = -i -m64 -O -g
SRC = *.d
LIBS = -L-lGL -L-ldl -L-lpthread -L-lstdc++ -L-lglfw

# ---- imgui libs
IMGUI_DIR   := cimgui/imgui
CIMGUI_DIR  := cimgui

IMGUI_LIB = libimgui.a
CIMGUI_LIB = libcimgui.a

IMGUI_CORE_CPP := \
	$(IMGUI_DIR)/imgui.cpp \
	$(IMGUI_DIR)/imgui_draw.cpp \
	$(IMGUI_DIR)/imgui_tables.cpp \
	$(IMGUI_DIR)/imgui_widgets.cpp \
	$(IMGUI_DIR)/imgui_demo.cpp 

IMGUI_BACKENDS_CPP := \
	$(IMGUI_DIR)/backends/imgui_impl_glfw.cpp \
	$(IMGUI_DIR)/backends/imgui_impl_opengl3.cpp

CIMGUI_CPP := \
	$(CIMGUI_DIR)/cimgui.cpp \
	$(CIMGUI_DIR)/cimgui_impl.cpp 


CXXFLAGS += -std=c++17 -O2 -I$(IMGUI_DIR) -I$(IMGUI_DIR)/backends -I$(CIMGUI_DIR) `pkg-config --cflags glfw3`

IMGUI_OBJS = $(IMGUI_CORE_CPP:.cpp=.o) $(IMGUI_BACKENDS_CPP:.cpp=.o)
CIMGUI_OBJS = $(CIMGUI_CPP:.cpp=.o)

all: $(TARGET)

$(TARGET): $(SRC) $(IMGUI_LIB) $(CIMGUI_LIB)
	$(DC) $(VERSION) $(DCFLAGS) main.d -of=$(TARGET) -L$(CIMGUI_LIB) -L$(IMGUI_LIB)  $(LIBS) 

$(CIMGUI_LIB): $(CIMGUI_OBJS)
	$(AR) rcs $@ $^

$(IMGUI_LIB): $(IMGUI_OBJS)
	$(AR) rcs $@ $^


$(IMGUI_OBJS): %.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@  -DIMGUI_IMPL_OPENGL_LOADER_GLAD=0

$(CIMGUI_OBJS): %.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@ $(CXXFLAGS)

run: $(TARGET)
	./$(TARGET)

clean_libs:
	rm -f $(IMGUI_OBJS) $(CIMGUI_OBJS) $(IMGUI_LIB) $(CIMGUI_LIB)

clean:
	rm -f $(TARGET) *.o
