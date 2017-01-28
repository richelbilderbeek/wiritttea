#ifndef WIRITTTEA_H
#define WIRITTTEA_H

#include <string>
#include <vector>

///Get the filenames of files that have no species tree
std::vector<std::string> get_species_tree_na(const std::vector<std::string>& filenames) noexcept;

///Does this file have a species tree?
bool has_species_tree(const std::string& filename) noexcept;

///Does this file lack a species tree?
bool has_species_tree_na(const std::string& filename) noexcept;

#endif // WIRITTTEA_H
