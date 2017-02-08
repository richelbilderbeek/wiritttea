#include "parameters.h"

#include <cassert>
#include <fstream>
#include <iostream>
#include <iterator>

#include "helper.h"

parameters::parameters(
  const double age,
  const double erg,
  const double eri,
  const std::string filename,
  const double mutation_rate,
  const int n_alignments,
  const int n_beast_runs,
  const int nspp,
  const double scr,
  const int seed,
  const int sequence_length,
  const double sirg,
  const double siri
) : m_age{age},
    m_erg{erg},
    m_eri{eri},
    m_filename{filename},
    m_mutation_rate{mutation_rate},
    m_n_alignments{n_alignments},
    m_n_beast_runs{n_beast_runs},
    m_nspp{nspp},
    m_scr{scr},
    m_seed{seed},
    m_sequence_length{sequence_length},
    m_sirg{sirg},
    m_siri{siri}
{

}

std::string create_header_parameters() noexcept
{
  return R"("","rng_seed","sirg","siri","scr","erg","eri","age","mutation_rate","n_alignments","sequence_length","nspp","n_beast_runs")";
}

parameters create_null_parameters() noexcept
{
  const double age{};
  const double erg{};
  const double eri{};
  const std::string filename{};
  const double mutation_rate{};
  const int n_alignments{};
  const int n_beast_runs{};
  const int nspp{};
  const double scr{};
  const int seed{};
  const int sequence_length{};
  const double sirg{};
  const double siri{};
  return parameters(
    age,
    erg,
    eri,
    filename,
    mutation_rate,
    n_alignments,
    n_beast_runs,
    nspp,
    scr,
    seed,
    sequence_length,
    sirg,
    siri
  );
}

parameters read_from_rda(const std::string& filename)
{
  /*
  "","rng_seed","sirg","siri","scr","erg","eri","age","mutation_rate","n_alignments","sequence_length","nspp","n_beast_runs"
  "article_1_3_0_3_0_940.RDa",940,0.5,0.5,1e+06,0,0,15,0.5,2,1000,1000,2
  */
  const std::string r_filename{"tmp_read_from_rda.R"};
  const std::string csv_filename{"tmp_read_from_rda.csv"};
  delete_if_present(r_filename);
  delete_if_present(csv_filename);
  {
    std::ofstream f(r_filename);
    f
      << "library(wiritttea)" << '\n'
      << "df <- wiritttea::collect_files_parameters("
        << "filenames = c(\"" << filename << "\"))" << '\n'
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
  assert(lines.size() == 2);
  const std::vector<std::string> fields = seperate_string(lines[1], ',');
  assert(fields.size() == 13);
  const double age{std::stod(fields[7])};
  const double erg{std::stod(fields[5])};
  const double eri{std::stod(fields[6])};
  const double mutation_rate{std::stod(fields[8])};
  const int n_alignments{std::stoi(fields[9])};
  const int n_beast_runs{std::stoi(fields[12])};
  const int nspp{std::stoi(fields[11])};
  const double scr{std::stod(fields[4])};
  const int seed{std::stoi(fields[1])};
  const int sequence_length{std::stoi(fields[10])};
  const double sirg{std::stod(fields[2])};
  const double siri{std::stod(fields[3])};
  return parameters(
    age,
    erg,
    eri,
    filename,
    mutation_rate,
    n_alignments,
    n_beast_runs,
    nspp,
    scr,
    seed,
    sequence_length,
    sirg,
    siri
  );


}

parameters read_from_rda_safe(const std::string& filename) noexcept
{
  try
  {
    return read_from_rda(filename);
  }
  catch (std::exception&)
  {
    return create_null_parameters();
  }
}

std::ostream& operator<<(std::ostream& os, const parameters& p) noexcept
{
  os
    << "\"" << p.m_filename << "\"" << ',' //Row name [0]
    << p.m_seed << ',' //rng_seed [1]
    << p.m_sirg << ',' //sirg [2]
    << p.m_siri << ',' //siri [3]
    << p.m_scr << ',' //scr [4]
    << p.m_erg << ',' //erg [5]
    << p.m_eri << ',' //eri [6]
    << p.m_age << ',' //age [7]
    << p.m_mutation_rate << ',' //mutation_rate [8]
    << p.m_n_alignments << ',' //n_alignments [9]
    << p.m_sequence_length << ',' //sequence_length [10]
    << p.m_nspp << ',' //nspp [11]
    << p.m_n_beast_runs //n_beast_runs [12]
  ;
  /*
  "","rng_seed","sirg","siri","scr","erg","eri","age","mutation_rate","n_alignments","sequence_length","nspp","n_beast_runs"
  "article_1_3_0_3_0_940.RDa",940,0.5,0.5,1e+06,0,0,15,0.5,2,1000,1000,2
  */
  return os;
}
