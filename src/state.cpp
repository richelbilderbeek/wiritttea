#include "state.h"

state::state(const std::string& filename)
  : m_filename{filename},
    m_n_taxa{-1},
    m_nltt_stats{create_null_nltt_stats()},
    m_parameters{create_null_parameters()},
    m_species_tree{tribool::unknown}
{
}
