FILE(GLOB OC_LIB_SRC
  OC_ELECTRONS.f90
  OC_FUNCTIONS.f90
  )
ADD_LIBRARY(OC_LIB OBJECT  ${OC_LIB_SRC})


