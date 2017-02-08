#ifndef NLTT_STAT_H
#define NLTT_STAT_H

#include <string>

class nltt_stat
{
public:
  nltt_stat(
    const int ai,
    const double nltt_stat_value,
    const int pi,
    const int si,
    const int sti
  );

  ///[2] Alignment Index
  int m_ai;

  ///[5] nLTT statistic
  double m_nltt_stat;

  ///[3] Posterior Index
  int m_pi;

  ///[4] Sample Index
  int m_si;

  ///[1] Species Tree Index
  int m_sti;

  friend std::ostream& operator<<(std::ostream& os, const nltt_stat& p) noexcept;
};

///Create the header for operator<<
std::string create_header_nltt_stat() noexcept;

nltt_stat to_nltt_stat(const std::string& line);

std::ostream& operator<<(std::ostream& os, const nltt_stat& p) noexcept;

#endif // NLTT_STAT_H
