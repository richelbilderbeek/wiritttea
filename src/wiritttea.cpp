#include "wiritttea.h"

#include <algorithm>
#include <cassert>
#include <fstream>
#include <iostream>
#include <future>
#include <stdexcept>

#include "helper.h"

esses calc_esses(const std::string& filename)
{
  std::clog << "calc_esses on " << filename << '\n';
  const std::string r_filename{"tmp_calc_ess.R"};
  const std::string csv_filename{"tmp_calc_ess.csv"};
  delete_if_present(r_filename);
  delete_if_present(csv_filename);
  {
    std::ofstream f(r_filename);
    f
      << "library(wiritttea)" << '\n'
      << "df <- wiritttea::collect_file_esses(filename = \"" << filename << "\")" << '\n'
      << "write.csv(df, \"" << csv_filename << "\")" << '\n'
    ;
  }
  const int error{
    std::system((std::string("Rscript ") + r_filename).c_str())
  };
  if (error)
  {
    throw std::runtime_error("Rscript failed");
  }
  //"filename", "sti", "ai", "pi", "min_ess"
  const std::vector<std::string> all_lines = file_to_vector(csv_filename);
  const std::vector<std::string> lines = remove_first(all_lines);
  esses my_esses;
  my_esses.reserve(lines.size());
  std::transform(
    std::begin(lines),
    std::end(lines),
    std::back_inserter(my_esses),
    [](const std::string& line)
    {
      return to_ess_safe(line);
    }
  );
  return my_esses;
}

esses calc_esses_safe(const std::string& filename) noexcept
{
  try
  {
    return calc_esses(filename);
  }
  catch (std::exception&)
  {
    return esses(8, create_null_ess());
  }
}

int count_n_taxa(const std::string& filename)
{
  const std::string r_filename{"tmp_count_n_taxa.R"};
  const std::string csv_filename{"tmp_count_n_taxa.csv"};
  delete_if_present(r_filename);
  delete_if_present(csv_filename);
  {
    std::ofstream f(r_filename);
    f
      << "library(wiritttea)" << '\n'
      << "df <- wiritttea::collect_species_tree_n_taxa(filename = \"" << filename << "\")" << '\n'
      << "write.csv(df, \"" << csv_filename << "\")" << '\n'
    ;
  }
  const int error{
    std::system((std::string("Rscript ") + r_filename).c_str())
  };
  if (error)
  {
    throw std::runtime_error("Rscript failed");
  }
  const std::vector<std::string> lines = file_to_vector(csv_filename);
  assert(lines.size() == 2);
  const std::vector<std::string> fields = seperate_string(lines[1], ',');
  assert(fields.size() == 2);
  const std::string n_taxa = fields[1];
  if (n_taxa == "NA") return 0;
  return std::stoi(n_taxa);
}

int count_n_taxa_safe(const std::string& filename) noexcept
{
  try
  {
    return count_n_taxa(filename);
  }
  catch (std::exception&)
  {
    return 0;
  }
}

void fill_states(std::vector<state>& states) noexcept
{
  int i=0;
  for (state& s: states)
  {
    std::cout << s.m_filename << ": ";
    const std::string tmp_csv_filename{
        std::string("tmp_fill_states_")
      + std::to_string(i)
      + std::string(".csv")
    };
    const std::string tmp_r_filename{
        std::string("tmp_fill_states_")
      + std::to_string(i)
      + std::string(".R")
    };
    delete_if_present(tmp_csv_filename);
    delete_if_present(tmp_r_filename);
    if (!"Is OK")
    {
      const bool ok = has_species_tree_safe(s.m_filename);
      s.m_species_tree = ok ? tribool::ok : tribool::na;
      std::cout << (ok ? "OK, ": "NA\n");
    }
    if ("ess")
    {
      s.m_esses = calc_esses_safe(s.m_filename);
      for (const auto& ess: s.m_esses)
      {
        std::cout << ess << '\n';
      }
    }
    if (!"n_taxa")
    {
      s.m_n_taxa = count_n_taxa_safe(s.m_filename);
      std::cout << s.m_n_taxa << '\n';
    }
    if (!"parameters")
    {
      s.m_parameters = read_parameters_from_rda_safe(s.m_filename);
      std::cout << s.m_parameters << ", ";
    }
    if (!"nltt_stats")
    {
      s.m_nltt_stats = read_nltt_stats_from_rda_safe(
        s.m_filename,
        tmp_csv_filename,
        tmp_r_filename
      );
      std::cout << s.m_nltt_stats.size();
    }
    std::cout << '\n';
  }
}

void fill_states_parallel(std::vector<state>& states) noexcept
{
  std::vector<std::future<nltt_stats>> new_states;
  const int sz = states.size();

  std::clog << "Start all threads\n";
  {
    new_states.reserve(sz);
    int i=0;
    for (state& s: states)
    {
      const std::string tmp_csv_filename{
          std::string("tmp_fill_states_")
        + std::to_string(i)
        + std::string(".csv")
      };
      const std::string tmp_r_filename{
          std::string("tmp_fill_states_")
        + std::to_string(i)
        + std::string(".R")
      };
      delete_if_present(tmp_csv_filename);
      delete_if_present(tmp_r_filename);
      new_states.push_back(
        std::async(
          std::launch::async,
          read_nltt_stats_from_rda_safe,
          s.m_filename,
          tmp_csv_filename,
          tmp_r_filename
        )
      );
      ++i;
    }
  }
  assert(new_states.size() == states.size());

  std::clog << "Convert futures to states\n";
  for (int i=0; i!=sz; ++i)
  {
    states[i].m_nltt_stats = new_states[i].get();
  }

}

bool has_species_tree(const std::string& filename)
{
  const std::string r_filename{"tmp_has_species_tree.R"};
  const std::string csv_filename{"tmp_has_species_tree.csv"};
  delete_if_present(r_filename);
  delete_if_present(csv_filename);
  {
    std::ofstream f(r_filename);
    f
      << "library(wiritttea)" << '\n'
      << "df <- wiritttea::collect_species_tree_n_taxa(filename = \"" << filename << "\")" << '\n'
      << "write.csv(df, \"" << csv_filename << "\")" << '\n'
    ;
  }
  const int error{
    std::system((std::string("Rscript ") + r_filename).c_str())
  };
  if (error)
  {
    throw std::runtime_error("Rscript failed");
  }
  const std::vector<std::string> lines = file_to_vector(csv_filename);
  assert(lines.size() == 2);
  const std::vector<std::string> fields = seperate_string(lines[1], ',');
  assert(fields.size() == 2);
  const std::string n_taxa = fields[1];
  if (n_taxa == "NA") return false;
  assert(std::stoi(n_taxa) > 0);
  return true;
}

bool has_species_tree_safe(const std::string& filename) noexcept
{
  try
  {
    return has_species_tree(filename);
  }
  catch (std::exception&)
  {
    return false;
  }
}

bool has_species_tree_na(const std::string& filename) noexcept
{
  return !has_species_tree(filename);
}

