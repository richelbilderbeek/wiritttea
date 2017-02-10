#include "helper.h"

#include <boost/algorithm/string/find_iterator.hpp> //Line 248

#include <cassert>
#include <chrono>
#include <iomanip>
#include <fstream>
#include <iostream>
#include <sstream>

#include <boost/algorithm/string/split.hpp>

void delete_file(const std::string& filename)
{
  if(!is_regular_file(filename))
  {
    std::stringstream msg;
    msg << __func__ << ": "
      << "can only delete existing files, "
      << "filename supplied: '"
      << filename << "' was not found"
    ;
    throw std::invalid_argument(msg.str());
  }
  std::remove(filename.c_str());

  if(is_regular_file(filename))
  {
    std::stringstream msg;
    msg << __func__ << ": "
      << "failed to delete existing file '"
      << filename << "'"
    ;
    throw std::invalid_argument(msg.str());
  }
}

void delete_if_present(const std::string& filename)
{
  if (is_regular_file(filename))
  {
    delete_file(filename);
  }
}

std::string extract_filename(const std::string& s)
{
   const auto i = s.rfind('/', s.length());
   if (i != std::string::npos)
   {
      return s.substr(i+1, s.length() - i);
   }
   //No path seperators
   return s;
}
std::vector<std::string> file_to_vector(const std::string& filename)
{
  if(!is_regular_file(filename))
  {
    std::stringstream msg;
    msg << __func__ << ": "
      << "can only convert existing files, "
      << "filename supplied: '"
      << filename << "' was not found"
    ;
    throw std::invalid_argument(msg.str());
  }
  assert(is_regular_file(filename));
  std::vector<std::string> v;
  std::ifstream in{filename.c_str()};
  assert(in.is_open());
  //Without this test in release mode,
  //the program might run indefinitely when the file does not exists
  for (int i=0; !in.eof(); ++i)
  {
    std::string s;
    std::getline(in,s);
    v.push_back(s); //Might throw std::bad_alloc
  }
  //Remove empty line at back of vector
  if (!v.empty() && v.back().empty()) v.pop_back();
  return v;
}


bool is_regular_file(const std::string& filename) noexcept
{
  std::fstream f;
  f.open(filename.c_str(),std::ios::in);
  return f.is_open();
}

std::vector<std::string> remove_first(
  std::vector<std::string> v
)
{
  if (v.empty())
  {
    throw std::invalid_argument("Cannot remove absent first line");
  }
  v.erase(std::begin(v));
  return v;
}


std::vector<std::string> seperate_string(
  const std::string& input,
  const char seperator
)
{
  std::istringstream is(input);
  std::vector<std::string> v;
  for (
    std::string sub;
    std::getline(is, sub, seperator);
    v.push_back(sub))
  {} //!OCLINT Indeed, this is an empty loop, and should be
  return v;
}

void show_time() noexcept
{
  const auto now = std::chrono::system_clock::now();
  const auto now_c = std::chrono::system_clock::to_time_t(now);
  std::cout << std::put_time(std::localtime(&now_c), "%c") << '\n';
}
