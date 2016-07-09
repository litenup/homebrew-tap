require 'formula'
class Yaafe < Formula
  homepage "https://github.com/Yaafe"
  url "https://github.com/Yaafe/Yaafe/archive/v0.65.1.tar.gz"
  version "0.65.1"
  sha256 "4dd9602d857c2fbb84834b6e559e93ee1cffc1025fd2911f443c23f812fb1987"

  depends_on 'cmake' => :build
  depends_on 'argtable'
  depends_on 'libsndfile'
  depends_on 'numpy' => :python
  depends_on 'mpg123' if ARGV.include? '--with-mpg123'
  depends_on 'hdf5' if ARGV.include? '--with-hdf5'
  depends_on 'fftw' if ARGV.include? '--with-fftw'

  def options
    [
      ['--with-fftw', "Enable use of FFTW to compute Fast Fourier transforms"],
      ['--with-hdf5', "Enable HDF5 output format"],
      ['--with-lapack', "Enable some audio features (LSF)"],
      ['--with-matlab-mex', "Enable building of Matlab MEX to extract features within Matlab environment"],
      ['--with-mpg123', "Enable reading audio from MP3 files"],
      ['--without-sndfile', "Disable reading audio from WAV files (enabled by default)"],
      ['--with-timers', "Enable timers for debugging purposes"]
    ]
  end

  def install
    args = std_cmake_parameters.split
    args << "-DCMAKE_PREFIX_PATH=#{prefix}"
    args << "-DWITH_FFTW3=ON" if ARGV.include? '--with-fftw'
    args << "-DWITH_HDF5=ON" if ARGV.include? '--with-hdf5'
    args << "-DWITH_LAPACK=ON" if ARGV.include? '--with-lapack'
    args << "-DWITH_MATLAB_MEX=ON" if ARGV.include? '--with-matlab-mex'
    args << "-DWITH_MPG123=ON" if ARGV.include? '--with-mpg123'
    args << "-WITH_SNDFILE=OFF" if ARGV.include? '--without-sndfile'
    args << "-DWITH_TIMERS=ON" if ARGV.include? '--with-timers'

    system "cmake", '.', *args

    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Yaafe was installed to #{prefix}.  Before using Yaafe, you must update your environment with:
      export YAAFE_PATH="#{prefix}/yaafe_extensions"
      export PATH="$PATH:#{bin}"
      export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:#{lib}"
      export PYTHONPATH="$PYTHONPATH:#{prefix}/python_packages"
    If you are using Matlab, set your Matlab path with:
      export MATLABPATH="$MATLABPATH:#{prefix}/matlab"
    EOS
  end
end