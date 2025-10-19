// cpp/imgui_glue.cpp
#include "imgui/imgui.h"

#include "imgui/backends/imgui_impl_opengl3.h"
#include "imgui/backends/imgui_impl_glfw.h"

#include <GLFW/glfw3.h>

extern "C" {

// Create + init Dear ImGui with GLFW+OpenGL3 backends.
// Pass your GLFWwindow* and a GLSL version string like "#version 330".
void ImGui_Backend_Init(GLFWwindow* window, const char* glsl_version)
{
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();

    // Optional: tweak IO flags here (keyboard nav, docking, etc.)
    // ImGuiIO& io = ImGui::GetIO(); (void)io;

    ImGui_ImplGlfw_InitForOpenGL(window, /*install_callbacks=*/true);
    ImGui_ImplOpenGL3_Init(glsl_version);
}

void ImGui_Backend_NewFrame()
{
    ImGui_ImplOpenGL3_NewFrame();
    ImGui_ImplGlfw_NewFrame();
    ImGui::NewFrame();
}

void ImGui_Backend_Render()
{
    ImGui::Render();
    ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());
}

void ImGui_Backend_Shutdown()
{
    ImGui_ImplOpenGL3_Shutdown();
    ImGui_ImplGlfw_Shutdown();
    ImGui::DestroyContext();
}

} // extern "C"

