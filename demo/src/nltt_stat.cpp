#include "nltt_stat.h"

#include <iostream>

#include "helper.h"


nltt_stat::nltt_stat(
  const int ai,
  const double nltt_stat_value,
  const int pi,
  const int si,
  const int sti
) : m_ai{ai},
    m_nltt_stat{nltt_stat_value},
    m_pi{pi},
    m_si{si},
    m_sti{sti}
{

}

std::string create_header_nltt_stat() noexcept
{
  return R"("","sti","ai","pi","si","nltt_stat")";
}

nltt_stat create_null_nltt_stat() noexcept
{
  const int ai{};
  const double nltt_stat_value{};
  const int pi{};
  const int si{};
  const int sti{};

  return nltt_stat(
    ai,
    nltt_stat_value,
    pi,
    si,
    sti
  );
}

nltt_stat to_nltt_stat(const std::string& line)
{
  /*

  "","sti","ai","pi","si","nltt_stat"
  "1",1,1,1,1,NA
  "8000",2,2,2,1000,NA

  */
  const std::vector<std::string> fields = seperate_string(line, ',');
  const int ai{std::stoi(fields[2])};

  const double nltt_stat_value{
    fields[5] == "NA" ? -1.0 : std::stod(fields[5])
  };
  const int pi{std::stoi(fields[3])};
  const int si{std::stoi(fields[4])};
  const int sti{std::stoi(fields[1])};

  return nltt_stat(
    ai,
    nltt_stat_value,
    pi,
    si,
    sti
  );

}

std::ostream& operator<<(std::ostream& os, const nltt_stat& p) noexcept
{
  /*

  "","sti","ai","pi","si","nltt_stat"
  "1",1,1,1,1,NA
  "8000",2,2,2,1000,NA

  */
  //Do not show the row index here, directly start at the STI

  os
    << p.m_sti << ','
    << p.m_ai << ','
    << p.m_pi << ','
    << p.m_si << ','
  ;
  if (p.m_nltt_stat < 0.0)
  {
    os << "NA";
  }
  else
  {
    os << p.m_nltt_stat;
  }
  return os;
}
