module glfw3_imgui_bindings;

import bindbc.glfw;

import importc_cimgui;

nothrow @nogc extern (C++) {
    void ImGui_ImplGlfw_InitForOpenGL(GLFWwindow*, bool);
    void ImGui_ImplOpenGL3_Init(const char*);
    void ImGui_ImplOpenGL3_NewFrame();
    void ImGui_ImplGlfw_NewFrame();
    void ImGui_ImplOpenGL3_RenderDrawData(ImDrawData*);
    void ImGui_ImplOpenGL3_Shutdown();
    void ImGui_ImplGlfw_Shutdown();
}