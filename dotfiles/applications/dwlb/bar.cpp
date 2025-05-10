#include <array>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <unistd.h>

void get_current_date_time(std::string *result) {
  time_t timestamp = time(NULL);
  struct tm datetime_info = *localtime(&timestamp);

  char output_buffer[50];

  strftime(output_buffer, sizeof(output_buffer), "%H:%M %d/%m", &datetime_info);

  *result = output_buffer;
}

void get_system_volume(std::string *result) {
  std::string ICON_MUTE = "  ";
  std::string ICON_AUDIO = "  ";

  constexpr const char *CMD =
      "wpctl get-volume @DEFAULT_SINK@ | awk '{ print $2, $3 }'";

  std::string output_line;
  FILE *fp = nullptr;

  // Use a std::array as a buffer for fgets
  std::array<char, 256>
      buffer; // Increased buffer slightly, though wpctl output is small

  fp = popen(CMD, "r");
  if (fp == nullptr) {
    std::cerr << "ERROR: Failed to run command: " << CMD << std::endl;
    return;
  }

  // Read the output from the command
  if (fgets(buffer.data(), buffer.size(), fp) != nullptr) {
    output_line = buffer.data(); // Convert C-string buffer to std::string
  } else {
    // This case handles if fgets fails or reads nothing (e.g., command produced
    // no output)
    std::cerr << "ERROR: Failed to read output from command." << std::endl;
    pclose(fp); // Still need to close the pipe
    return;
  }

  // Ensure pclose is called even if parsing fails later
  // We can capture its status after processing.
  // int status = pclose(fp); // Moved pclose to the end

  float vol_value = 0.0f;
  bool muted = false;

  // Check for mute status first from the raw line
  if (output_line.find("[MUTED]") != std::string::npos) {
    muted = true;
  }

  // Use stringstream to parse the volume value
  std::stringstream ss(output_line);
  if (!(ss >> vol_value)) {
    std::cerr << "ERROR: Could not parse volume value from: " << output_line
              << std::endl;
    pclose(fp); // Close before early return
    return;
  }

  // Convert volume to percentage and round it
  int volume_percent = static_cast<int>(std::round(vol_value * 100.0f));

  if (volume_percent == 0 || muted) {
    result->append(ICON_MUTE);
  } else {
    result->append(ICON_AUDIO);
  }

  result->append(std::to_string(volume_percent));
  result->append("%");

  int status = pclose(fp);
  if (status == -1) {
    std::cerr << "ERROR: pclose failed." << std::endl;
  } else {
    if (WIFEXITED(status)) {
      int exit_status = WEXITSTATUS(status);
      if (exit_status != 0) {
        std::cerr << "WARN: Command exited with status " << exit_status
                  << std::endl;
        // You might not want to print this if output was successfully parsed,
        // as `awk` might exit non-zero if input pipe closes unexpectedly
        // but after it has produced output.
      }
    } else if (WIFSIGNALED(status)) {
      std::cerr << "WARN: Command killed by signal " << WTERMSIG(status)
                << std::endl;
    }
  }
}

void get_wifi_status(std::string *result) {
  std::string ICON_WIFI = "  ";
  std::string ICON_PLANE = "  ";

  int wifi_status;

  wifi_status = system("nmcli conn show --active | grep wifi");

  if (wifi_status == 0) {
    // Successul
    result->append(ICON_WIFI);
    return;
  }

  result->append(ICON_PLANE);
}

void get_battery(std::string *result) {
  std::string ICON_CHG = "⚡  ";
  std::string ICON_DIS = "  ";

  std::string battery;
  std::string battery_capacity;
  std::string battery_state;

  std::ifstream BatteryCapacity("/sys/class/power_supply/BAT1/capacity");
  std::ifstream BatteryState("/sys/class/power_supply/BAT1/status");

  std::getline(BatteryCapacity, battery_capacity);
  std::getline(BatteryState, battery_state);

  if (battery_state == "Discharging") {
    result->append(ICON_DIS);
  } else {
    result->append(ICON_CHG);
  }

  result->append(battery_capacity);
  result->append("%");

  // Close the file
  BatteryCapacity.close();
  BatteryState.close();
}

std::string escape_for_shell_single_quotes(const std::string &s) {
  std::string escaped_s;
  escaped_s.reserve(s.length()); // Pre-allocate to avoid multiple reallocations

  for (char c : s) {
    if (c == '\'') {
      escaped_s += "'\\''"; // Replaces ' with '\''
    } else {
      escaped_s += c;
    }
  }
  return escaped_s;
}

void update_status(
    const std::string &status_param) { // 1. Pass by const reference
  // 2. Escape the status string to prevent command injection
  std::string escaped_status = escape_for_shell_single_quotes(status_param);

  // Using std::string concatenation is fine for simple cases.
  // For more complex constructions, std::ostringstream could be used.
  std::string command = "dwlb -status all '" + escaped_status + "'";

  // For debugging, you might want to see the command
  // std::cout << "Executing command: " << command << std::endl;

  // 3. Check the return value of system()
  int return_code = system(command.c_str()); // system() takes a const char*

  if (return_code != 0) {
    // Handle error: The command failed or couldn't be executed
    std::cerr << "Error: Command failed with exit code " << return_code
              << std::endl;
    std::cerr << "Command was: " << command << std::endl;
    // You might want to throw an exception here depending on your error
    // handling strategy throw std::runtime_error("Failed to execute dwlb
    // command.");
  } else {
    // Optionally, log success
    // std::cout << "Command executed successfully." << std::endl;
  }
}

int main() {
  std::string battery_string;
  std::string wifi_string;
  std::string volume_string;
  std::string date_string;

  while (true) {
    battery_string = "";
    wifi_string = "";
    volume_string = "";
    date_string = "";

    get_battery(&battery_string);
    get_wifi_status(&wifi_string);
    get_system_volume(&volume_string);
    get_current_date_time(&date_string);

    std::string status;

    status.append(battery_string);
    status.append(" | ");
    status.append(volume_string);
    status.append(" | ");
    status.append(wifi_string);
    status.append("| ");
    status.append(date_string);

    // std::cout << status << std::endl;
    update_status(status);

    sleep(1);
  }

  return 0;
}
