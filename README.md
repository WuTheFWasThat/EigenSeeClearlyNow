# EIGEN SEE CLEARLY NOW #

## OVERVIEW ##

This is a project to help anyone learning linear algebra visualize its concepts.

It is still an early-stage work in progress.

Click [here](https://jeffwu-eigen.terminal.com/) for a demo.

## SETUP ##

### Option 1 - On Terminal.com ###

Make an account on Terminal.com if you don't have one.
Log in, and start [this snapshot](https://www.terminal.com/snapshot/c0409926af9adfefb358320c21dcd53f883a778e75dde28f360a917c7ffad442).

### Option 2 - Set up yourself ###

Install:

    git clone https://github.com/WuTheFWasThat/EigenSeeClearlyNow.git
    cd EigenSeeClearlyNow
    npm install

Start:

    npm start

Then just hit port 8080 on localhost

## TO-DO: ##

- matrix * vector
- matrix * matrix
- matrices!
- make gridding better?
- make distances/etc aspects of view configurable?
- make keyboard handler more flexible?

- make prod version work: `NODE_ENV=production ./node_modules/.bin/coffee server.coffee`

### IDEAS: ###

- determinant
- independence (as a game?)
- make span game 2! (hint: Try rotating the camera so that one basis vector lines up with the origin. You should be able to visually prove that this game is impossible!)
  - refactor span game!
- symmetric matrix
- orthogonal matrix
- inverse
- eigenvalue
- something where you find eigenvalue by sliding around lambda in (A - lambda I)?
- SVD

### TOPICS: ###

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
  4. have orthonormal set of eigenvalues

more:
  eigenvectors
  spectral theora

advanced:
  dual space?
  direct sum?

## KNOWN ISSUES: ##

## CONTRIBUTE: ##

Feel free to send me pull requests!

For the visualizations, we use [three.js](https://github.com/mrdoob/three.js).  Many thanks to them!

### CONTRIBUTORS: ###
- Jeff Wu
- Yang Hong
