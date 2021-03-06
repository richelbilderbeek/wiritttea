#ifndef WIRITTTEA_H
#define WIRITTTEA_H

#include <string>
#include <vector>
#include "state.h"
#include "esses.h"

///Calculate the effective sample size
///Throws if something went wrong
esses calc_esses(const std::string& filename);

esses calc_esses_impl_1(const std::string& filename);
esses calc_esses_impl_2(const std::string& filename);

///Calculate the effective sample size
///Returns zero if something went wrong
esses calc_esses_safe(const std::string& filename) noexcept;



///Count the number of taxa in the species tree
///Throws if something went wrong
int count_n_taxa(const std::string& filename);

///Count the number of taxa in the species tree
///Returns zero if something went wrong
int count_n_taxa_safe(const std::string& filename) noexcept;

///Get the filenames of files that have no species tree
void fill_states(std::vector<state>& states) noexcept;
void fill_states_parallel(std::vector<state>& states) noexcept;

///Does this file have a species tree?
///Will throw if something goes wrong
bool has_species_tree(const std::string& filename);

///Does this file have a species tree?
///If an error occurs, false is returned
bool has_species_tree_safe(const std::string& filename) noexcept;

///Does this file lack a species tree?
bool has_species_tree_na(const std::string& filename) noexcept;

#endif // WIRITTTEA_H
