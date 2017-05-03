#ifndef R_HELPER_H
#define R_HELPER_H

///R helper functions
///All these write R scripts
#include <string>

///Run the R script
void run_r_script(const std::string& r_script_filename);

///Set R's working directory to the path specified
void set_r_cwd(const std::string& path);

#endif // R_HELPER_H
