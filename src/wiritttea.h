#ifndef WIRITTTEA_H
#define WIRITTTEA_H

#include <string>
#include <vector>
#include "state.h"

///Get the filenames of files that have no species tree
void set_species_tree_states(std::vector<state>& states) noexcept;

///Does this file have a species tree?
bool has_species_tree(const std::string& filename) noexcept;

///Does this file lack a species tree?
bool has_species_tree_na(const std::string& filename) noexcept;

#endif // WIRITTTEA_H
