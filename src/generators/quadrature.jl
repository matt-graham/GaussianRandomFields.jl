## quadrature.jl : nystrom integration methods

"""
Abstract type `QuadratureRule`

The following quadrature rules are implemented:

- `Midpoint::QuadratureRule`: the midpoint rule
- `Trapezoidal::QuadratureRule`: the trapezoidal rule
- `Simpson::QuadratureRule`: Simpson's rule
- `GaussLegendre::QuadratureRule`: Gauss-Legendre quadrature rule
- `EOLE::QuadratureRule`: expansion-optimal linear estimation

See also: [`Midpoint`](@ref), [`Trapezoidal`](@ref), [`Simpson`](@ref), [`GaussLegendre`](@ref), [`EOLE`](@ref)
"""
abstract type QuadratureRule end

"""
    GaussLegendre()

Gauss-Legendre quadrature method.

See also: [`Midpoint`](@ref), [`Trapezoidal`](@ref), [`Simpson`](@ref), [`EOLE`](@ref)
"""
struct GaussLegendre <: QuadratureRule end

"""
    EOLE()

Expansion-optimal linear estimation.

See also: [`Midpoint`](@ref), [`Trapezoidal`](@ref), [`Simpson`](@ref), [`GaussLegendre`](@ref)
"""
struct EOLE <: QuadratureRule end

"""
    Simpson()

Simpson's method.

See also: [`Midpoint`](@ref), [`Trapezoidal`](@ref), [`GaussLegendre`](@ref), [`EOLE`](@ref)
"""
struct Simpson <: QuadratureRule end

"""
    Midpoint()

The midpoint rule.

See also: [`Trapezoidal`](@ref), [`Simpson`](@ref), [`GaussLegendre`](@ref), [`EOLE`](@ref)
"""
struct Midpoint <: QuadratureRule end

"""
    Trapezoidal()

The trapezoidal rule.

See also: [`Midpoint`](@ref), [`Simpson`](@ref), [`GaussLegendre`](@ref), [`EOLE`](@ref)
"""
struct Trapezoidal <: QuadratureRule end

# get nodes and weights of Gauss-Legendre quadrature on [a,b]
function get_nodes_and_weights(n::Integer, a, b, q::GaussLegendre)
    nodes, weights = gausslegendre(n)
    weights = (b-a)/2*weights
    nodes = (b-a)/2*nodes .+ (a+b)/2
    return nodes, weights
end

# get nodes and weights of structured grid on [a,b]
function get_nodes_and_weights(n::Integer, a, b, q::EOLE)
    nodes = n == 1 ? [(a+b)/2] : range(a; stop = b,length = n)
    weights = fill((b-a) / n, n)
    return nodes, weights
end

# get nodes and weights of Simpson's rule on [a,b]
function get_nodes_and_weights(n::Integer, a, b, q::Simpson)
    iseven(n) || begin
        @warn "to use Simpson's rule, n must be even (received $(n)). I will continue with n = $(n+1)"
        n += 1
    end
    Δx = (b-a)/n
    nodes = a:Δx:b
    weights = repeat(2:2:4, outer=Int(n/2))
    weights[1] = 1
    push!(weights,1)
    weights *= Δx/3
    return nodes, weights
end

# get nodes and weights of Midpoint rule on [a,b]
function get_nodes_and_weights(n::Integer, a, b, q::Midpoint)
    Δx = (b-a)/n
    nodes = (a+Δx/2):Δx:(b-Δx/2)
    weights = fill(Δx, size(nodes))
    return nodes, weights
end

# get nodes and weights of Trapezoidal rule on [a,b]
function get_nodes_and_weights(n::Integer, a, b, q::Trapezoidal)
    Δx = (b-a)/n
    nodes = a:Δx:b
    weights = fill(Δx, length(nodes))
    weights[1] /= 2
    weights[end] /= 2
    return nodes, weights
end

## EigenSolvers
"""
Abstract type `AbstractEigenSolver`

The following eigensolvers are implemented:
-`EigenSolver<:AbstractEigenSolver`: eigenvalue decomposition using **eigen**
-`EigsSolver<:AbstractEigenSolver`: eigenvalue decomposition using **eigs**

See also: [`EigenSolver`](@ref), [`EigsSolver`](@ref)
"""
abstract type AbstractEigenSolver end

"""
    EigenSolver()

Eigenvalue decomposition using **eigen**.

See also: [`EigsSolver`](@ref)
"""
struct EigenSolver <: AbstractEigenSolver end

compute(A, n, ::EigenSolver) = eigen(A, sortby=λ->-abs(real(λ)))

"""
    EigsSolver()

Eigenvalue decomposition using **eigs**.

See also: [`EigenSolver`](@ref)
"""
struct EigsSolver <: AbstractEigenSolver end

compute(A, n, ::EigsSolver) = eigs(A, nev=n, ritzvec=true, which=:LM, v0=randn(size(A,1))) 
