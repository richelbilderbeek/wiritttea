#include "ess.h"

#include <iostream>
#include <stdexcept>

#include "helper.h"

ess::ess(
  const int ai,
  const std::string filename,
  const int min_ess,
  const int pi,
  const int sti
) : m_ai{ai},
    m_filename{filename},
    m_min_ess{min_ess},
    m_pi{pi},
    m_sti{sti}
{

}

std::string create_header_ess() noexcept
{
  return R"("filename", "sti", "ai", "pi", "min_ess")";
}

ess create_null_ess() noexcept
{
  const int ai{};
  const std::string filename{"null_ess.RDa"};
  const int min_ess{};
  const int pi{};
  const int sti{};
  return ess(
    ai,
    filename,
    min_ess,
    pi,
    sti
  );
}

ess to_ess(const std::string& line)
{
  const std::vector<std::string> words = seperate_string(line, ',');
  if (words.size() != 5)
  {
    throw std::invalid_argument("Line must have five words");
  }
  const int min_ess{
    words[4] == "NA" ? 0 : std::stoi(words[4])
  };
  return ess(
    std::stoi(words[2]), //ai
    words[0], //filename
    min_ess, //min_ess
    std::stoi(words[3]), //pi
    std::stoi(words[1]) //sti
  );
}

ess to_ess_safe(const std::string& line) noexcept
{
  try
  {
    return to_ess(line);
  }
  catch (std::exception&)
  {
    return create_null_ess();
  }
}

std::ostream& operator<<(std::ostream& os, const ess& e) noexcept
{
  os
    << e.m_filename << ','
    << e.m_sti << ','
    << e.m_ai << ','
    << e.m_pi << ','
    << e.m_min_ess
  ;
  return os;
}
