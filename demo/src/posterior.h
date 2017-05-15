#ifndef POSTERIOR_H
#define POSTERIOR_H

#include <vector>
#include "posterior_row.h"

using posterior = std::vector<posterior_row>;

std::string create_header_posterior() noexcept;

posterior to_posterior(const std::vector<std::string>& text);

posterior load_posterior(const std::string& filename);

std::ostream& operator<<(std::ostream& os, const posterior& e) noexcept;

#endif // POSTERIOR_H
