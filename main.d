import bindbc.opengl;
import bindbc.glfw;

import glfw3_imgui_bindings;

import importc_cimgui;

import std.stdio;

int main() {
	GLFWwindow* window;
	GLFWSupport retGLFW = loadGLFW();
	if (retGLFW != glfwSupport) {
		writeln("gflw failed to load");
		return 1;
	}

	glfwSetErrorCallback(&errorCallback);
	if (!glfwInit()) {
		writeln("gflw failed to init");
		return 1;
	}
	scope (exit)
		glfwTerminate();

	// Create window + GL context
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
	window = glfwCreateWindow(800, 600, "cimgui Hello", null, null);
	scope (exit) {
		glfwDestroyWindow(window);
	}
	if (!window) {
		writeln("create window failed");
		return 1;
	}
	glfwMakeContextCurrent(window);
	glfwSwapInterval(1); // vsync

	GLSupport retGL = loadOpenGL();
	if (retGL == GLSupport.badLibrary || retGL == GLSupport.noLibrary) {
		writeln("load openGL failed");
		return -1;
	}

	// --- ImGui: create context BEFORE backend init ---
	ImGuiContext* ctx = igCreateContext(null);
	ImGuiIO* io = igGetIO_ContextPtr(ctx);
	io.ConfigFlags |= ImGuiConfigFlags_DockingEnable;

	cast(void) io;
	scope (exit) {
		igDestroyContext(ctx);
	}
	// Style first (optional)
	igStyleColorsDark(null);

	// Backend init AFTER context exists
	ImGui_ImplGlfw_InitForOpenGL(window, true);
	scope (exit) {
		ImGui_ImplGlfw_Shutdown();
	}
	ImGui_ImplOpenGL3_Init("#version 330");
	scope (exit) {
		ImGui_ImplOpenGL3_Shutdown();
	}
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
