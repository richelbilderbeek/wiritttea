#include "nltt_stats.h"

#include <algorithm>
#include <cassert>
#include <fstream>

#include "helper.h"
#include "r_helper.h"

nltt_stats::nltt_stats(
  std::string filename,
  std::vector<nltt_stat> v)
  : m_filename{filename},
    m_v{v}
{

}

std::string create_header_nltt_stats() noexcept
{
  return R"("","filename","sti","ai","pi","si","nltt_stat")";
}

nltt_stats create_null_nltt_stats() noexcept
{
  return nltt_stats("no.RDa", {} );
}

nltt_stats read_nltt_stats_from_rda(
  const std::string& filename,
  const std::string& tmp_csv_filename,
  const std::string& tmp_r_filename
)
{
  assert(!is_regular_file(tmp_r_filename));
  assert(!is_regular_file(tmp_csv_filename));
  {
    std::ofstream f(tmp_r_filename);
    f
      << "library(wiritttea)" << '\n'
      << "df <- wiritttea::collect_file_nltt_stats("
        << "filename = \"" << filename << "\")" << '\n'
      << "write.csv(df, \"" << tmp_csv_filename << "\")" << '\n'
    ;
  }
  run_r_script(tmp_r_filename);
  const std::vector<std::string> lines = file_to_vector(tmp_csv_filename);
  return read_nltt_stats_from_text(filename, lines);
}

nltt_stats read_nltt_stats_from_text(
  const std::string filename,
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
    [](const std::string& line) {
      return to_nltt_stat(line);
    }
  );
  return nltt_stats(filename, v);
}

nltt_stats read_nltt_stats_from_rda_safe(
  const std::string filename,
  const std::string tmp_csv_filename,
  const std::string tmp_r_filename
) noexcept
{
  try
  {
    return read_nltt_stats_from_rda(
      filename,
      tmp_csv_filename,
      tmp_r_filename
    );
  }
  catch (std::exception&)
  {
    return create_null_nltt_stats();
  }
}

std::ostream& operator<<(std::ostream& os, const nltt_stats& p) noexcept
{
  const auto& v = p.m_v;
  const int sz = v.size();
  for (int i=0; i!=sz; ++i)
  {
    os
      << "\"" << (i + 1) << "\","
      << "\"" << extract_filename(p.m_filename) << "\","
      << v[i] << '\n';
  }


  /*

  "","sti","ai","pi","si","nltt_stat"
  "filename.txt",1,1,1,1,NA
  "filename.txt",2,2,2,1000,NA

  */

  /*
  const auto& v = p.m_v;
  for (const auto& line: v)
  {
    os << "\"" << extract_filename(p.m_filename) << "\"," << line << '\n';
  }
  */
  /*

  "","sti","ai","pi","si","nltt_stat"
  "1",1,1,1,1,NA
  "8000",2,2,2,1000,NA

  */
  //First row starts with "1"
  //const int sz = v.size();
  //for (int i=0; i!=sz; ++i)
  //{
  //  os << "\"" << (i + 1) << "\"," << v[i] << '\n';
  //}
  return os;
}
