#ifndef POSTERIOR_ROW_H
#define POSTERIOR_ROW_H

#include <iosfwd>
#include <string>

struct posterior_row
{
  posterior_row(
    const double birth_death = 0.0, //[7]
    const double birth_rate_2 = 0.0, //[8]
    const double likelihood = 0.0, //[3]
    const double posterior = 0.0, //[2]
    const double prior = 0.0, //[4]
    const double relative_death_rate_2 = 0.0, //[9]
    const int sample = 0, //[1]
    const double tree_height = 0.0, //[6]
    const double tree_likelihood = 0.0 //[5]
  );
  double m_birth_death; //[7]
  double m_birth_rate_2; //[8]
  double m_likelihood; //[3]
  double m_posterior; //[2]
  double m_prior; //[4]
  double m_relative_death_rate_2; //[9]
  int m_sample; //[1]
  double m_tree_height; //[6]
  double m_tree_likelihood; //[5]
};

std::string create_header_posterior_row() noexcept;

posterior_row create_null_posterior_row() noexcept;

posterior_row to_posterior_row(const std::string& line);

posterior_row to_posterior_row_safe(const std::string& line) noexcept;

std::ostream& operator<<(std::ostream& os, const posterior_row& e) noexcept;

#endif // POSTERIOR_ROW_H
