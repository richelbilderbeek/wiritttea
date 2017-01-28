#include <exception>
#include <iostream>
#include <string>
#include <vector>
#include "wiritttea.h"
#include "helper.h"

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
    std::vector<std::string> args;
    for (int i=1; i!=argc; ++i) //Skip the exe itself
    {
      args.push_back(std::string(argv[i]));
    }
    if (argc == 1)
    {
      show_help();
      return 0;
    }
    std::cout << "No species trees: " << (argc - 1) << '\n';
    const std::vector<std::string> filenames = get_species_tree_na(args);
    for (const auto& filename: filenames)
    {
      std::cout << filename << '\n';
    }
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

