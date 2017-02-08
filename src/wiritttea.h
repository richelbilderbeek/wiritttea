#ifndef WIRITTTEA_H
#define WIRITTTEA_H

#include <string>
#include <vector>
#include "state.h"

///Count the number of taxa in the species tree
///Throws if something went wrong
int count_n_taxa(const std::string& filename);

///Count the number of taxa in the species tree
///Returns zero if something went wrong
int count_n_taxa_safe(const std::string& filename) noexcept;

///Get the filenames of files that have no species tree
void fill_states(std::vector<state>& states) noexcept;

///Does this file have a species tree?
///Will throw if something goes wrong
bool has_species_tree(const std::string& filename);

///Does this file have a species tree?
///If an error occurs, false is returned
bool has_species_tree_safe(const std::string& filename) noexcept;

///Does this file lack a species tree?
bool has_species_tree_na(const std::string& filename) noexcept;

#endif // WIRITTTEA_H
