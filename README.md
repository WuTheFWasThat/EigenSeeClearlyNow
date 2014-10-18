# EIGEN SEE CLEARLY NOW #

## OVERVIEW ##

This is a project to help anyone learning linear algebra visualize its concepts.

It is still a very, very early-stage work in progress.

A demo should be available at https://jeffwu-eigen.terminal.com/

## SETUP ##

### Option 1 - On Terminal.com ###

Make an account on Terminal.com if you don't have one.  Log in, and start this snapshot: https://www.terminal.com/snapshot/c89d0aaa382a9242995afc053ac74ad3d787d0010511d8cad9aacd9426d3ed29

### Option 2 - Set up yourself ###

Install:

    git clone https://github.com/WuTheFWasThat/EigenSeeClearlyNow.git
    cd EigenSeeClearlyNow
    npm install

Start:

    npm start

Then just hit port 8080 on localhost

## ROUGH ROAD MAP: ##

- Vectors
  1.  show a vector
      show a vector in 3 dimensions
  2.  vector addition
      show vector addition commutes (with a parallelogram?)
- Matrices
  1. explain that a matrix is a linear transformation
  2. start with a diagonal square matrix
  3. add upper right diagonal
  4. add other entries
  5. note that the transformation doesn't have to be into a space of the same dimension
  6. multiplication is composition of the transformations

- subspace
- Nullspace
- Colspace
- span
- independence
- bases
Square matrices:
  1. matrix is invertible if 1 to 1 inverse matrix
  2. change of basis
  Symmetric matrices:
  2. two vectors are orthogonal if dot product is zero.
     to see this, change bases
  3. orthogonal projection
  Determinant
  1. area of parallelogram

more:
  eigenvectors
  spectral theora
  SVD?


advanced:
  dual space?
  direct sum?

## KNOWN ISSUES: ##

## CONTRIBUTE: ##

Feel free to send me pull requests!
