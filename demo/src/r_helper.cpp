#include "r_helper.h"
#include "helper.h"

#include <fstream>
#include <stdexcept>

void run_r_script(const std::string& r_script_filename)
{
  const int error{
    std::system((std::string("Rscript ") + r_script_filename).c_str())
  };
  if (error)
  {
    throw std::runtime_error("R script failed");
  }
}

void set_r_cwd(const std::string& path)
{
  const std::string r_filename{"tmp_set_r_cwd.R"};
  {
    std::ofstream f(r_filename);
    f << "setwd(\""<< path << "\")" << '\n';
  }
  run_r_script(r_filename);
}
