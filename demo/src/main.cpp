#include <cassert>
#include <exception>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include "wiritttea.h"
#include "helper.h"
#include "r_helper.h"
#include "state.h"

void save_correct_trees(const std::vector<state>& states)
{
  std::ofstream f("correct_species_trees.csv");
  for (const auto& state: states)
  {
    if (state.m_species_tree == tribool::ok)
    {
      f << state.m_filename << '\n';
    }
  }
}

void save_esses(const std::vector<state>& states)
{
  std::ofstream f("esses.csv");
  f << create_header_ess() << '\n';
  f << R"("filename", "sti", "ai", "pi", "min_ess")" << '\n';

  for (const auto& state: states)
  {
    for (const auto& ess: state.m_esses)
    {
      f << ess << '\n';
    }
  }
}

void save_incorrect_trees(const std::vector<state>& states)
{
  std::ofstream f("incorrect_species_trees.csv");
  for (const auto& state: states)
  {
    if (state.m_species_tree == tribool::na)
    {
      f << state.m_filename << '\n';
    }
  }
}

void save_n_taxa(const std::vector<state>& states)
{
  std::ofstream f("n_taxa.csv");
  f << R"("filename","n_taxa")" << '\n';
  for (const auto& state: states)
  {
    f << surround_with_quotes(extract_filename(state.m_filename)) << ','
      << state.m_n_taxa << '\n';
  }
}

void save_nltt_stats(const std::vector<state>& states)
{
  std::ofstream f("nltt_stats.csv");
  f << create_header_nltt_stats() << '\n';
  for (const auto& state: states)
  {
    f << state.m_nltt_stats << '\n';
  }
}

void save_parameters(const std::vector<state>& states)
{
  std::ofstream f("parameters.csv");
  f << create_header_parameters() << '\n';
  for (const auto& state: states)
  {
    f << state.m_parameters << '\n';
  }
}


void show_help()
{
  std::cout
    << "wiritttea" << '\n'
    << "------------" << '\n'
    << '\n'
    << "Usage:" << '\n'
    << '\n'
    << "  wiritttea a.RDa b.RDa" << '\n'
    << "  wiritttea `ls *.RDa`" << '\n'
    << "  wiritttea `ls *.RDa` > results.csv" << '\n'
    << '\n'
  ;
}


int main(int argc, char* argv[])
{
  assert(extract_filename("/home/richel/README.md") == "README.md");
  assert(extract_path("/home/richel/README.md") == "/home/richel");

  //Set R working directory to this file its path
  set_r_cwd(extract_path(argv[0]));

  try
  {
    std::vector<state> states;
    for (int i=1; i!=argc; ++i) //Skip the exe itself
    {
      states.push_back(state(std::string(argv[i])));
    }

    if (argc == 1)
    {
      show_help();
      return 0;
    }
    std::cout << "No files: " << (argc - 1) << '\n';
    fill_states(states);
    //fill_states_parallel(states);
    //save_incorrect_trees(states);
    //save_correct_trees(states);
    save_esses(states);
    //save_n_taxa(states);
    //save_parameters(states);
    //save_nltt_stats(states);
  }
  catch (std::exception& e)
  {
    std::cerr << "Error: " << e.what() << '\n';
    return 1;
  }
  catch (...)
  {
    std::cerr << "Error: Unknown\n";
    return 1;
  }
}

