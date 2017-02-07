#include "state.h"

state::state(const std::string& filename)
  : m_filename{filename},
    m_n_taxa{-1},
    m_species_tree{tribool::unknown}
{
}
