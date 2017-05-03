#ifndef PBD_HELPER_H
#define PBD_HELPER_H

#include <string>
#include <vector>

///Deletes a file. Throws if:
///(1) if file is absent before deletion, or
///(2) if file is still present after attempt
void delete_file(const std::string& filename);

///Deletes the file if it is present. Throws if:
///the file is still present after attempt
void delete_if_present(const std::string& filename);

///Extract the filename from a full path
///e.g. '/home/richel/README.md' becomes 'README.md'
std::string extract_filename(const std::string& filename);

///Extract the path from a full path
///e.g. '/home/richel/README.md' becomes '/home/richel'
std::string extract_path(const std::string& filename);

std::vector<std::string> file_to_vector(const std::string& filename);

///Checks if a file is present
bool is_regular_file(const std::string& filename) noexcept;

///Creates a copy without the first element
std::vector<std::string> remove_first(std::vector<std::string> v);

///Seperates a std::string. For example,
///seperate_string("1,2", ',') becomes {"1","2"}
std::vector<std::string> seperate_string(
  const std::string& input,
  const char seperator
);

///Show the current time
void show_time() noexcept;

///Surround the string by quotes, 's' becomes '"s"'
std::string surround_with_quotes(std::string s);

#endif // PBD_HELPER_H
