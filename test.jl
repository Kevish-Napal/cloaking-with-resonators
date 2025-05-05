using Plots;
using MultipleScattering
using Statistics
using JLD2

include("Resonator.jl")
include("functions.jl")

# Where to plot and which frequencies
M=N = 30
list_ω = [1+c/3.0 for c = 0:9]
list_ω[4] = ω0;
list_ω[7] = ω2;

Cockpit_radius = 10.0
particle_medium_1 =  Acoustic(2; ρ=1.0, c=0.0);
Cockpit_Center = 35;

layer_radius = Cockpit_radius*(1+0.7)
big_sphere = Particle(particle_medium_1, Circle([Cockpit_Center,0.0], layer_radius));

plot(big_sphere)
savefig("big_sphere.png")


typeofresult = FrequencySimulationResult{Float64, 2, 1};
result_uncloaked = Array{typeofresult}(undef, 10) ;


Threads.@threads for i =1:10
  result_uncloaked[i] = Solve([list_ω[i]],[big_sphere],M,N);
end

# i=7
# PlotMyWave(list_ω[i],big_sphere,result_uncloaked[i])

save_object("uncloaked.jld2", result_uncloaked)
