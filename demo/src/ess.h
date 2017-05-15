#ifndef ESS_H
#define ESS_H

#include <iosfwd>
#include <string>

class ess
{
public:
  ess(
    const int ai,
    const std::string filename,
    const int min_ess,
    const int pi,
    const int sti
  );
  int m_ai;
  std::string m_filename;
  int m_min_ess;
  int m_pi;
  int m_sti;

};

//Do not forget to set somewhere:
//Sys.setenv("PKG_CXXFLAGS" = "-std=c++11")
std::string create_header_ess() noexcept;

ess create_null_ess() noexcept;

ess to_ess(const std::string& line);

ess to_ess_safe(const std::string& line) noexcept;


std::ostream& operator<<(std::ostream& os, const ess& e) noexcept;

#endif // ESS_H
