#ifndef STATE_H
#define STATE_H

#include "string"

enum class tribool { unknown, ok, na };

class state
{
public:
  state(const std::string& filename);
  std::string m_filename;
  int m_n_taxa; //-1 if NA
  tribool m_species_tree;
};

#endif // STATE_H
