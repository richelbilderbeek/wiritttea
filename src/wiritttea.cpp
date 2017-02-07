#include "wiritttea.h"

#include <algorithm>
#include <cassert>
#include <fstream>
#include <iostream>
#include <stdexcept>

#include "helper.h"

int count_n_taxa(const std::string& filename) noexcept
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
    //throw std::runtime_error("command failed");
    return 0;
  }
  const std::vector<std::string> lines = file_to_vector(csv_filename);
  assert(lines.size() == 2);
  const std::vector<std::string> fields = seperate_string(lines[1], ',');
  assert(fields.size() == 2);
  const std::string n_taxa = fields[1];
  if (n_taxa == "NA") return 0;
  return std::stoi(n_taxa);
}

void set_species_tree_states(std::vector<state>& states) noexcept
{
  for (state& s: states)
  {
    if (s.m_species_tree == tribool::unknown)
    {
      const bool ok = has_species_tree(s.m_filename);
      s.m_species_tree = ok ? tribool::ok : tribool::na;
      std::cout << s.m_filename << ": " << (ok ? "OK": "NA") << '\n';
    }
    assert(s.m_species_tree != tribool::unknown);
    if (s.m_n_taxa < 0)
    {
      s.m_n_taxa = count_n_taxa(s.m_filename);
      std::cout << s.m_filename << ": " << s.m_n_taxa << '\n';
    }
  }
}

bool has_species_tree(const std::string& filename) noexcept
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
    //throw std::runtime_error("command failed");
    return false;
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

bool has_species_tree_na(const std::string& filename) noexcept
{
  return !has_species_tree(filename);
}

