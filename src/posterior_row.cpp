#include "posterior_row.h"

#include <iostream>
#include <stdexcept>

#include "helper.h"

//Do not forget to set somewhere:
//Sys.setenv("PKG_CXXFLAGS"="-std=c++11")

posterior_row::posterior_row(
  const double birth_death, //[7]
  const double birth_rate_2, //[8]
  const double likelihood, //[3]
  const double posterior, //[2]
  const double prior, //[4]
  const double relative_death_rate_2, //[9]
  const int sample, //[1]
  const double tree_height, //[6]
  const double tree_likelihood //[5]
) :
  m_birth_death{birth_death},
  m_birth_rate_2{birth_rate_2},
  m_likelihood{likelihood},
  m_posterior{posterior},
  m_prior{prior},
  m_relative_death_rate_2{relative_death_rate_2},
  m_sample{sample},
  m_tree_height{tree_height},
  m_tree_likelihood{tree_likelihood}
{

}

std::string create_header_posterior_row() noexcept
{
  //"","Sample","posterior","likelihood","prior","treeLikelihood","TreeHeight","BirthDeath","birthRate2","relativeDeathRate2"
  return R"("","Sample","posterior","likelihood","prior","treeLikelihood","TreeHeight","BirthDeath","birthRate2","relativeDeathRate2")";
}

posterior_row create_null_posterior_row() noexcept
{
  return {};
}

posterior_row to_posterior_row(const std::string& line)
{
  const std::vector<std::string> words = seperate_string(line, ',');
  if (words.size() != 10)
  {
    throw std::invalid_argument("Line must have ten words");
  }
  return posterior_row(
    std::stod(words[7]), //BirthDeath
    std::stod(words[8]), //birthRate2
    std::stod(words[3]), //likelihood
    std::stod(words[2]), //posterior
    std::stod(words[4]), //prior
    std::stod(words[9]), //relativeDeathRate2
    std::stoi(words[1]), //Sample
    std::stod(words[6]), //TreeHeight
    std::stod(words[5])  //treeLikelihood
  );
}

posterior_row to_posterior_row_safe(const std::string& line) noexcept
{
  try
  {
    return to_posterior_row(line);
  }
  catch (std::exception&)
  {
    return create_null_posterior_row();
  }
}

std::ostream& operator<<(std::ostream& os, const posterior_row& e) noexcept
{
  os
    << e.m_birth_death << ','
    << e.m_birth_rate_2 << ','
    << e.m_likelihood << ','
    << e.m_posterior << ','
    << e.m_prior << ','
    << e.m_relative_death_rate_2 << ','
    << e.m_sample << ','
    << e.m_tree_height << ','
    << e.m_tree_likelihood
  ;
  return os;
}
