#include <exception>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include "wiritttea.h"
#include "helper.h"
#include "state.h"

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
    set_species_tree_states(states);
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
    {
      std::ofstream f("n_taxa.csv");
      for (const auto& state: states)
      {
        f << state.m_filename << ": " << state.m_n_taxa << '\n';
      }
    }
    //std::cout << "Done" << '\n';
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
