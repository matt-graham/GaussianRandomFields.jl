using GaussianRandomFields
#using TimeIt

#=
c = CovarianceFunction(1,Exponential(0.1))
pts = 0:1/500:1
grf = GaussianRandomField(c,CirculantEmbedding(),pts)
@show grf
@show sample(grf)
plot(grf,n=6), show()
=#

m = CovarianceFunction(1,Matern(1.0,1.0))
pts = 0:1/1001:1
grf = GaussianRandomField(m,CirculantEmbedding(),pts,padding=8)
@show grf
sample(grf)
#@timeit sample(grf)
#@show sample(grf)
plot(grf,n=3), show()

#=
mat = Matern(0.75,2.0)
cov = CovarianceFunction(3,mat)
pts = 0:0.2:1
grf = GaussianRandomField(cov,KarhunenLoeve(100),pts,pts,pts)

plot(grf); show()
=#

#=
p = readdlm("../data/star.p")
t = readdlm("../data/star.t",Int64)
@show size(p)
@show size(t)
m = Matern(0.75,2.0)
c = CovarianceFunction(2,m)
g = GaussianRandomField(c,KarhunenLoeve(100),p,t)#,quad=Trapezoidal())
#plot_trisurf(g); show()
#tricontourf(g); show()
#plot_eigenvalues(g); show()
#for i = 1:25
    plot_eigenfunction(g,1,linewidth=0); show()
#end
=#

#=
exp1 = Exponential(0.5,p=1)
exp2 = Exponential(0.5,p=1)
#exp1 = Exponential(0.5)
#exp2 = Exponential(0.5)
scov = SeparableCovarianceFunction(exp1,exp2)
grf = GaussianRandomField(scov,KarhunenLoeve(300),0:0.01:1,0:0.01:1)
@show grf
#plot_eigenvalues(grf); show()
#for i = 1:25
#plot_eigenfunction(grf,i); show()
#end
#
#contourf(grf); show()
plot_eigenvalues(grf); show()
for i = 1:5
	plot(grf); show()
end
=#

#=
exp = Exponential(0.5)
cov = CovarianceFunction(3,exp)
grf = GaussianRandomField(cov,KarhunenLoeve(300),0:0.05:0.5,0:0.05:2,0:0.05:1)
#=
for i = 1:25
	plot_eigenfunction(grf,i); show()
end
=#
#plot_eigenvalues(grf); show()
#for i = 1:5
	plot(grf); show()
#end
=#
