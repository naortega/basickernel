void memory_copy(char *src, char *dest, unsigned int n) {
	unsigned int i;
	for(i = 0; i < n; ++i)
	{
		dest[i] = src[i];
	}
}
