#include "state.h"

state::state(const std::string& filename)
  : m_filename{filename},
    m_species_tree{tribool::unknown}
{
}
