#include "nltt_stats.h"

#include <algorithm>
#include <cassert>
#include <fstream>

#include "helper.h"

nltt_stats::nltt_stats(std::vector<nltt_stat> v)
  : m_v{v}
{

}

std::string create_header_nltt_stats() noexcept
{
  return create_header_nltt_stat();
}

nltt_stats create_null_nltt_stats() noexcept
{
  return nltt_stats( {} );
}

nltt_stats read_nltt_stats_from_rda(const std::string& filename)
{
  const std::string csv_filename{"tmp_read_nltt_stats_from_rda.csv"};
  const std::string r_filename{"tmp_read_nltt_stats_from_rda.R"};
  delete_if_present(r_filename);
  delete_if_present(csv_filename);
  {
    std::ofstream f(r_filename);
    f
      << "library(wiritttea)" << '\n'
      << "df <- wiritttea::collect_file_nltt_stats("
        << "filename = \"" << filename << "\")" << '\n'
      << "write.csv(df, \"" << csv_filename << "\")" << '\n'
    ;
  }
  const int error{
    std::system((std::string("Rscript ") + r_filename).c_str())
  };
  if (error)
  {
    throw std::runtime_error("R script failed");
  }
  const std::vector<std::string> lines = file_to_vector(csv_filename);
  return read_nltt_stats_from_text(lines);
}

nltt_stats read_nltt_stats_from_text(
  const std::vector<std::string>& text_with_header)
{
  assert(!text_with_header.empty());
  const std::vector<std::string> text = remove_first(text_with_header);
  std::vector<nltt_stat> v;
  v.reserve(text.size());
  std::transform(
    std::begin(text),
    std::end(text),
    std::back_inserter(v),
    [](const auto& line) {
      return to_nltt_stat(line);
    }
  );
  return v;
}

nltt_stats read_nltt_stats_from_rda_safe(const std::string& filename) noexcept
{
  try
  {
    return read_nltt_stats_from_rda(filename);
  }
  catch (std::exception&)
  {
    return create_null_nltt_stats();
  }
}

std::ostream& operator<<(std::ostream& os, const nltt_stats& p) noexcept
{
  /*

  "","sti","ai","pi","si","nltt_stat"
  "1",1,1,1,1,NA
  "8000",2,2,2,1000,NA

  */
  //First row starts with "1"
  //os << create_header_nltt_stats();

  const auto& v = p.m_v;
  const int sz = v.size();
  for (int i=0; i!=sz; ++i)
  {
    os << "\"" << (i + 1) << "\"," << v[i] << '\n';
  }
  return os;
}
