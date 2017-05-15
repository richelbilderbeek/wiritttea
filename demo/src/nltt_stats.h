#ifndef NLTT_STATS_H
#define NLTT_STATS_H

#include <string>
#include <vector>
#include "nltt_stat.h"

class nltt_stats
{
public:
  nltt_stats(
    std::string filename,
    std::vector<nltt_stat> v);

  int size() const noexcept { return m_v.size(); }

private:

  std::string m_filename;
  std::vector<nltt_stat> m_v;

  friend std::ostream& operator<<(std::ostream& os, const nltt_stats& p) noexcept;
};

///Create the header for operator<<
std::string create_header_nltt_stats() noexcept;

///Create empty nltt_stats
nltt_stats create_null_nltt_stats() noexcept;

///Read the nltt_stats from an RDa file
/// @param filename the name of the RDa file
/// @param tmp_csv_filename name of a temporary .csv file created
/// @param tmp_r_filename name of a temporary .R file created
nltt_stats read_nltt_stats_from_rda(
  const std::string& filename,
  const std::string& tmp_csv_filename,
  const std::string& tmp_r_filename
);

///Read the nltt_stats from an RDa file
///Returns a null nltt_stats set if an exception is thrown
///Do not use std::string& for thread safety
nltt_stats read_nltt_stats_from_rda_safe(
  const std::string filename,
  const std::string tmp_csv_filename,
  const std::string tmp_r_filename
) noexcept;

///Read the nltt_stats from lines of text
nltt_stats read_nltt_stats_from_text(
  const std::string filename,
  const std::vector<std::string>& text);


std::ostream& operator<<(std::ostream& os, const nltt_stats& p) noexcept;

#endif // NLTT_STATS_H
