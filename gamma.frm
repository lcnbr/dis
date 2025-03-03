*-- Declare the functions for gamma matrices and the gamma chain
Functions g, m, b;

Dimension d;

Indices m0,m21,m2,m22,m24,m23;
*-- Define the gamma chain expression
L F = g_(1,m0, m21, m2, m22,m0, m24, m2, m23
);

*-- Compute the Dirac trace of the gamma chain using tracen
tracen,1;

.sort

*-- Print the simplified result
Print;

.end
