#ifndef PARAMETERS_H
#define PARAMETERS_H

#include <string>

class parameters
{
public:


  /// @param align_length Number of nucleotides an alignment is
  /// @param birth_rate Probability an incipient or good lineages gives rise
  ///   to a new lineage
  /// @param ext_rate Probability an incipient or good lineages goes extinct
  /// @param filename name of the parameter file
  /// @param scr Speciation Completion Rate, probability an incipient
  ///   lineage becomes a good species
  /// @param mut_rate Per-nucleotide mutation rate
  /// @param seed RNG seed
  parameters(
    const double age,
    const double erg,
    const double eri,
    const std::string filename,
    const double mutation_rate,
    const int n_alignments,
    const int n_beast_runs,
    const int nspp,
    const double scr,
    const int seed,
    const int sequence_length,
    const double sirg,
    const double siri
  );

private:

  ///Crown age, million years ago
  double m_age;

  /// Extinction Rate Good species
  double m_erg;

  /// Extinction Rate Incipient species
  double m_eri;

  /// Filename
  std::string m_filename;

  /// Per-nucleotide mutation rate
  double m_mutation_rate;

  /// Number of alignments per representative species tree
  int m_n_alignments;

  /// The number of BEAST2 runs
  int m_n_beast_runs;

  /// Number of Samples per BEAST2 Posterior
  int m_nspp;

  /// Speciation Completion Rate
  /// Probability an incipient lineage becomes a good species
  double m_scr;

  /// RNG seed
  int m_seed;

  /// Number of nucleotides an alignment is
  int m_sequence_length;

  /// Speciation Initiation Rate Good
  /// Probability a good lineage gives rise to a new incipient lineage
  double m_sirg;

  /// Speciation Initiation Rate Incipient
  /// Probability an incipient lineage gives rise to a new incipient lineage
  double m_siri;

  friend std::ostream& operator<<(std::ostream& os, const parameters& p) noexcept;
};

///Create the header for operator<<
std::string create_header_parameters() noexcept;

///Create empty parameters
parameters create_null_parameters() noexcept;

///Read the parameters from an RDa file
parameters read_from_rda(const std::string& filename);

///Read the parameters from an RDa file
///Returns a null parameters set if an exception is thrown
parameters read_from_rda_safe(const std::string& filename) noexcept;

std::ostream& operator<<(std::ostream& os, const parameters& p) noexcept;

#endif // PARAMETERS_H
