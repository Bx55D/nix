//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	{"", "/home/bud/.applications/dwmblocks/check_audio.sh",		1, 		0},
	{"", "/home/bud/.applications/dwmblocks/charging_status.sh",		1, 		0},
	{"", "/home/bud/.applications/dwmblocks/wifi_check.sh",			1, 		0},
	{"", "date '+%d %b %H:%M'",						5,		0},
};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = " | ";
static unsigned int delimLen = 5;
