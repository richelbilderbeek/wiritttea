#include "wiritttea.h"

#include <algorithm>
#include <cassert>
#include <fstream>
#include <iostream>
#include <stdexcept>

#include "helper.h"

std::vector<std::string> get_species_tree_na(const std::vector<std::string>& filenames) noexcept
{
  std::vector<std::string> v;
  std::copy_if(
    std::begin(filenames),
    std::end(filenames),
    std::back_inserter(v),
    [](const std::string& filename)
    {
      return has_species_tree_na(filename);
    }
  );
  return v;
}

bool has_species_tree(const std::string& filename) noexcept
{
  const std::string r_filename{"tmp_has_species_tree.R"};
  const std::string csv_filename{"tmp_has_species_tree.csv"};
  //delete_if_present(r_filename);
  //delete_if_present(csv_filename);
  std::ofstream f("tmp_script.R");
  f
    << "library(wiritttea)" << '\n'
    << "df <- collect_species_tree_n_taxa(filename = \"" << filename << "\")" << '\n'
    << "write.csv(df, \"" << csv_filename << "\")" << '\n'
  ;
  const int error{
    std::system((std::string("Rscript ") + r_filename).c_str())
  };
  if (error)
  {
    throw std::runtime_error("command failed");
  }
  const std::vector<std::string> lines = file_to_vector(csv_filename);
  assert(lines.size() == 3);
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

