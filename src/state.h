#ifndef STATE_H
#define STATE_H

#include "string"
#include "parameters.h"
#include "nltt_stats.h"
enum class tribool { unknown, ok, na };

class state
{
public:
  state(const std::string& filename);

  ///Name fo the filename
  std::string m_filename;

  ///Number of taxa in the species tree
  int m_n_taxa; //-1 if NA

  ///nLTT statistics distribution
  nltt_stats m_nltt_stats;

  ///Parameters
  parameters m_parameters;

  ///Does this file have a species tree?
  tribool m_species_tree;
};

#endif // STATE_H
