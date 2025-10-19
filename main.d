/// Simple example of a GLFW application that opens a window and draws a colored triangle
module app;

import glfw3.api;
import bindbc.opengl;

import glfw3_imgui_bindings;

import importc_cimgui;

version (linux) {
	pragma(lib, "libcimgui.a");
	pragma(lib, "libimgui.a");
}

int main() {
	GLFWwindow* window;
	glfwSetErrorCallback(&errorCallback);
	if (!glfwInit())
		return 1;
	scope (exit)
		glfwTerminate();

	// Create window + GL context
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
	window = glfwCreateWindow(800, 600, "cimgui Hello", null, null);
	scope (exit)
		glfwDestroyWindow(window);
	if (!window)
		return 1;
	glfwMakeContextCurrent(window);
	glfwSwapInterval(1); // vsync

	GLSupport retVal = loadOpenGL();
	if (retVal == GLSupport.badLibrary || retVal == GLSupport.noLibrary) {
		return -1;
	}

	// --- ImGui: create context BEFORE backend init ---
	ImGuiContext* ctx = igCreateContext(null);
	ImGuiIO* io = igGetIO_ContextPtr(ctx);
	cast(void) io;
	scope (exit)
		igDestroyContext(ctx);

	// Style first (optional)
	igStyleColorsDark(null);

	// Backend init AFTER context exists
	ImGui_ImplGlfw_InitForOpenGL(window, true);
	scope (exit)
		ImGui_ImplGlfw_Shutdown();

	ImGui_ImplOpenGL3_Init("#version 330");
	scope (exit)
		ImGui_ImplOpenGL3_Shutdown();

	// Main loop
	while (!glfwWindowShouldClose(window)) {
		glfwPollEvents();

		ImGui_ImplOpenGL3_NewFrame();
		ImGui_ImplGlfw_NewFrame();
		igNewFrame();

		static bool show_demo = true;
		igShowDemoWindow(&show_demo);

		igRender();

		int display_w, display_h;
		glfwGetFramebufferSize(window, &display_w, &display_h);
		glViewport(0, 0, display_w, display_h);
		glClearColor(0.45f, 0.55f, 0.60f, 1.00f);
		glClear(GL_COLOR_BUFFER_BIT);
		ImGui_ImplOpenGL3_RenderDrawData(igGetDrawData());

		glfwSwapBuffers(window);
	}

	return 0;
}

extern (C) @nogc nothrow void errorCallback(int error, const(char)* description) {
	import cstdio = core.stdc.stdio;

	cstdio.fprintf(cstdio.stderr, "Error: %s\n", description);
}
