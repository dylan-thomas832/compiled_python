%module example
%{
/* Put header files here or function declarations like below */
#define SWIG_FILE_WITH_INIT
#include "example.hpp"
%}

%include "example.hpp"
