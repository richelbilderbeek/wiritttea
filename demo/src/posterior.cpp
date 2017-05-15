#include "posterior.h"

#include <algorithm>
#include <cassert>

#include "helper.h"

posterior load_posterior(const std::string& filename)
{
  assert(is_regular_file(filename));
  //"","Sample","posterior","likelihood","prior","treeLikelihood","TreeHeight","BirthDeath","birthRate2","relativeDeathRate2"
  return to_posterior(file_to_vector(filename));
}

posterior to_posterior(const std::vector<std::string>& all_lines)
{
  const std::vector<std::string> lines = remove_first(all_lines);
  posterior p;
  p.reserve(lines.size());
  std::transform(
    std::begin(lines),
    std::end(lines),
    std::back_inserter(p),
    [](const std::string& line)
    {
      return to_posterior_row(line);
    }
  );
  return p;
}
