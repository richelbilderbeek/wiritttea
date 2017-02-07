#ifndef WIRITTTEA_H
#define WIRITTTEA_H

#include <string>
#include <vector>
#include "state.h"

///Count the number of taxa in the species tree
///Returns zero if something went wrong
int count_n_taxa(const std::string& filename) noexcept;

///Get the filenames of files that have no species tree
void set_species_tree_states(std::vector<state>& states) noexcept;

///Does this file have a species tree?
bool has_species_tree(const std::string& filename) noexcept;

///Does this file lack a species tree?
bool has_species_tree_na(const std::string& filename) noexcept;

#endif // WIRITTTEA_H
