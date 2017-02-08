#ifndef NLTT_STATS_H
#define NLTT_STATS_H

#include <string>
#include <vector>
#include "nltt_stat.h"

class nltt_stats
{
public:
  nltt_stats(std::vector<nltt_stat> v);

  int size() const noexcept { return m_v.size(); }

private:
  std::vector<nltt_stat> m_v;

  friend std::ostream& operator<<(std::ostream& os, const nltt_stats& p) noexcept;
};

///Create the header for operator<<
std::string create_header_nltt_stats() noexcept;

///Create empty nltt_stats
nltt_stats create_null_nltt_stats() noexcept;

///Read the nltt_stats from an RDa file
nltt_stats read_nltt_stats_from_rda(const std::string& filename);

///Read the nltt_stats from lines of text
nltt_stats read_nltt_stats_from_text(
  const std::vector<std::string>& text);

///Read the nltt_stats from an RDa file
///Returns a null nltt_stats set if an exception is thrown
nltt_stats read_nltt_stats_from_rda_safe(const std::string& filename) noexcept;

std::ostream& operator<<(std::ostream& os, const nltt_stats& p) noexcept;

#endif // NLTT_STATS_H
