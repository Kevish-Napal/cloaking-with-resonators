using Plots;
using MultipleScattering
using Statistics
using JLD2

include("Resonator.jl")
include("../MyJuliaFunctions/MultipleScattering/functions.jl")

# Where to plot and which frequencies
M=N = 30
list_ω = [1+c/3.0 for c = 0:9]
list_ω[4] = ω0;
list_ω[7] = ω2;

# Define the cockpit
Cockpit_radius = 10.0
particle_medium_1 =  Acoustic(2; ρ=1.0, c=0.0);
Cockpit_Center = 35;
Cockpit = Particle(particle_medium_1, Circle([Cockpit_Center,0.0], Cockpit_radius));
# result_Cockpit = Solve([ω0],[Cockpit],M,N);

# add cloaking
    # protection layer
layer_radius = Cockpit_radius*(1+0.7)
layer_particles = layer(1.0,2.0,0.5,
    t->layer_radius*cos(2π*t)+Cockpit_Center
    ,t->layer_radius*sin(2π*t)
    ,t->-2π*layer_radius*sin(2π*t)
    ,t->2π*layer_radius*cos(2π*t));

#     # Resonator layer
res_layer_radius = Cockpit_radius*1.4
res_layer_particles = resonator_layer(0.0,0.0,3.0,
    t->res_layer_radius*cos(2π*t)+Cockpit_Center
    ,t->res_layer_radius*sin(2π*t)
    ,t->-2π*res_layer_radius*sin(2π*t)
    ,t->2π*res_layer_radius*cos(2π*t)
    ,X);

super_cloaked = [Cockpit;res_layer_particles;layer_particles];
plot(super_cloaked)
savefig("cloaked3.png")


typeofcloaking = Array{Particle{2, Acoustic{Float64, 2}, Sphere{Float64, 2}}, 1};
typeofresult = FrequencySimulationResult{Float64, 2, 1};

# Create a list of Configurations
super_cloaked_random = Array{typeofcloaking}(undef, 10);
Threads.@threads for i = 1:10
    res_layer_particles = resonator_layer(0.0,0.0,3.0,
    t->res_layer_radius*cos(2π*t)+Cockpit_Center
    ,t->res_layer_radius*sin(2π*t)
    ,t->-2π*res_layer_radius*sin(2π*t)
    ,t->2π*res_layer_radius*cos(2π*t)
    ,X);

    super_cloaked_random[i] = [Cockpit;res_layer_particles;layer_particles];
end

# plot(super_cloaked_random[1])

A = [(j,i) for i=1:10, j=1:10]
result_super_cloaked_random = Array{typeofresult}(undef, 10,10) ;

Threads.@threads for i =1:100
  result_temp = Solve([list_ω[A[i][2]]],super_cloaked_random[A[i][1]],M,N);
  result_super_cloaked_random[i] = result_temp;
end

save_object("cloaking_resonators.jld2", result_super_cloaked_random)
save_object("cloaking_resonators_geometry.jld2", super_cloaked_random)
