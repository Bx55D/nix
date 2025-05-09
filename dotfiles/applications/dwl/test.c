#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

int main(){
	bool running = true;
	while (running == true){
		system("echo $0");
		sleep(2);
	}

	return 1;
}
