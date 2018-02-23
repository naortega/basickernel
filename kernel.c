void main() {
	/*
	 * point to first text cell of the video memory
	 */
	char *video_memory = (char*) 0xb8000;
	/*
	 * store the character 'X' there
	 */
	*video_memory = 'X';
}
