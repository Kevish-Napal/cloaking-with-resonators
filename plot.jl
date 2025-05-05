using Plots
using JLD2
using MultipleScattering
using DataFrames
using Statistics

include("Resonator.jl")
include("functions.jl")

# Where to plot and which frequencies
M=N = 30
list_ω = [1+c/3.0 for c = 0:9]
list_ω[4] = ω0;
list_ω[7] = ω2;


A = [(j,i) for i=1:10, j=1:10]


cloaking_resonators = load_object("Data/cloaking_resonators.jld2")
cloaking_squares = load_object("Data/cloaking_squares.jld2")
uncloaked = load_object("Data/uncloaked.jld2")

# sensors positions
sensors_bottomleft = [-30;-30]; sensors_topright = [-10,30];

plot()
for frq = 1:10;
ω = round(list_ω[frq]; digits = 2)

# no cloak
plot()
Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
visibility(uncloaked[frq],sensors_bottomleft,sensors_topright);
plot!(Sensors_vline,field_vline[:,1],ylim=(-1,1),label="")
display(plot!(size=(1000,300),title="no cloak - Sensors on vertical line x=$CX, ω=$ω"))

# squares
plot()
for config = 1:10
    Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
    visibility(cloaking_squares[config],sensors_bottomleft,sensors_topright);
    plot!(Sensors_vline,field_vline[:,frq],ylim=(-1,1),label="")
end
display(plot!(size=(1000,300),title="square - Sensors on vertical line x=$CX, ω=$ω"))

#resonators
plot()
for frq = 1:10;
ω = round(list_ω[frq]; digits = 2)
plot()
config = 1
    Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
    visibility(cloaking_resonators[frq,config],sensors_bottomleft,sensors_topright);
    plot!(Sensors_vline,field_vline[:,1],ylim=(-1,1),label="")
end
display(plot!(size=(1000,300),title="resonators - Sensors on vertical line x=$CX, ω=$ω"))
end


# Effect of cloaking
plot()
for frq = [4];
ω = round(list_ω[frq]; digits = 2)
config = 4
    Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
    visibility(cloaking_resonators[frq,config],sensors_bottomleft,sensors_topright);
    plot!(Sensors_vline,field_vline[:,1],ylim=(-1,1),label="cloaked",color=:blue)

    Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
    visibility(uncloaked[frq],sensors_bottomleft,sensors_topright);
    plot!(Sensors_vline,field_vline[:,1],ylim=(-1,1)
    ,label="uncloaked",color=:red
    ,linewidth=3, thickness_scaling = 1)
end

plot!(size=(1000,300),title="ω=$ω (resonant frequency ω₀)"
    ,xlabel = "position of sensors"
    ,ylabel= "measured field")
# savefig("general_effect4.png")


# Effect of cloaking
plot()
for frq = [6];
ω = round(list_ω[frq]; digits = 2)
config = 4
    Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
    visibility(cloaking_resonators[frq,config],sensors_bottomleft,sensors_topright);
    plot!(Sensors_vline,field_vline[:,1],ylim=(-1,1),label="cloaked",color=:blue)

    Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
    visibility(uncloaked[frq],sensors_bottomleft,sensors_topright);
    plot!(Sensors_vline,field_vline[:,1],ylim=(-1,1),label="uncloaked",color=:red,linewidth=3, thickness_scaling = 1)
end

plot!(size=(1000,300),title="ω=$ω"
,xlabel = "position of sensors"
,ylabel= "measured field")
# savefig("general_effect6.png")



# Effect of cloaking
plot()
for frq = [5];
ω = round(list_ω[frq]; digits = 2)
config = 1
    Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
    visibility(cloaking_resonators[frq,config],sensors_bottomleft,sensors_topright);
    plot!(Sensors_vline,field_vline[:,1],ylim=(-1,1),label="cloaked",color=:blue)

    Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
    visibility(uncloaked[frq],sensors_bottomleft,sensors_topright);
    plot!(Sensors_vline,field_vline[:,1],ylim=(-1,1),label="uncloaked",color=:red,linewidth=3, thickness_scaling = 1)
end

plot!(size=(1000,300),title="measured fields, ω=$ω")
# savefig("general_effect$frq.png")


# Average behavior
# resonant frq effect
iter = 0
for frq = 4;
    plot()
ω = round(list_ω[frq]; digits = 2)
Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
visibility(uncloaked[frq],sensors_bottomleft,sensors_topright);
plot!(Sensors_vline,field_vline[:,1],ylim=(-1,1),label="uncloaked",color=:red,linewidth=3, thickness_scaling = 1)
    for config = 1
        iter+=1
        Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
        visibility(cloaking_resonators[frq,config],sensors_bottomleft,sensors_topright);
        plot!(Sensors_vline,field_vline[:,1],ylim=(-1,1),label="cloaked $iter")
    end
    for config = [4,7]
        iter+=1
        Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
        visibility(cloaking_resonators[frq,config],sensors_bottomleft,sensors_topright);
        plot!(Sensors_vline,field_vline[:,1],ylim=(-1,1),label="cloaked $iter")
    end
display(plot!(size=(1000,300),title="ω=$ω  (resonant frequency ω₀)"
    ,xlabel = "position of sensors"
    ,ylabel= "measured field"))
savefig("general_effect_multifrq$frq.png")
end


# Average behavior
# resonant frq effect
iter = 0
for frq = 6;
    plot()
ω = round(list_ω[frq]; digits = 2)
Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
visibility(uncloaked[frq],sensors_bottomleft,sensors_topright);
plot!(Sensors_vline,field_vline[:,1],ylim=(-1,1),label="uncloaked",color=:red,linewidth=3, thickness_scaling = 1)
    for config = 1
        iter+=1
        Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
        visibility(cloaking_resonators[frq,config],sensors_bottomleft,sensors_topright);
        plot!(Sensors_vline,field_vline[:,1],ylim=(-1,1),label="cloaked $iter")
    end
    for config = [5,9]
        iter+=1
        Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
        visibility(cloaking_resonators[frq,config],sensors_bottomleft,sensors_topright);
        plot!(Sensors_vline,field_vline[:,1],ylim=(-1,1),label="cloaked $iter")
    end
display(plot!(size=(1000,300),title="ω=$ω"
    ,xlabel = "position of sensors"
    ,ylabel= "measured field"))
savefig("general_effect_multifrq$frq.png")
end

##################################################################
# Plot of cloaking with squares
sq_layer_particles = resonator_layer(0.0,0.0,3.0,
    t->res_layer_radius*cos(2π*t)+Cockpit_Center
    ,t->res_layer_radius*sin(2π*t)
    ,t->-2π*res_layer_radius*sin(2π*t)
    ,t->2π*res_layer_radius*cos(2π*t)
    ,XS);

fake_cloaked_random = [Cockpit;sq_layer_particles;layer_particles];
plot(fake_cloaked_random)
savefig("square_cloak.png")
# Average behavior
# squares frq effect
iter = 0
for frq = 4;
   plot()
ω = round(list_ω[frq]; digits = 2)
Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
visibility(uncloaked[frq],sensors_bottomleft,sensors_topright);
plot!(Sensors_vline,field_vline[:,1],ylim=(-1,1),label="uncloaked",color=:red,linewidth=3, thickness_scaling = 1)
   for config = 1
       iter+=1
       Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
       visibility(cloaking_squares[config],sensors_bottomleft,sensors_topright);
       plot!(Sensors_vline,field_vline[:,frq],ylim=(-1,1),label="cloaked $iter")
   end
   for config = [4,7]
       iter+=1
       Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
       visibility(cloaking_squares[config],sensors_bottomleft,sensors_topright);
       plot!(Sensors_vline,field_vline[:,frq],ylim=(-1,1),label="cloaked $iter")
   end
display(plot!(size=(1000,300),title="ω=$ω",xlabel = "position of sensors"
,ylabel= "measured field"))
savefig("square_multifrq$frq.png")
end


# Average behavior
# squares frq effect
iter = 0
for frq = 6;
   plot()
ω = round(list_ω[frq]; digits = 2)
Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
visibility(uncloaked[frq],sensors_bottomleft,sensors_topright);
plot!(Sensors_vline,field_vline[:,1],ylim=(-1,1),label="uncloaked",color=:red,linewidth=3, thickness_scaling = 1)
   for config = 1
       iter+=1
       Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
       visibility(cloaking_squares[config],sensors_bottomleft,sensors_topright);
       plot!(Sensors_vline,field_vline[:,frq],ylim=(-1,1),label="cloaked $iter")
   end
   for config = [5,9]
       iter+=1
       Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
       visibility(cloaking_squares[config],sensors_bottomleft,sensors_topright);
       plot!(Sensors_vline,field_vline[:,frq],ylim=(-1,1),label="cloaked $iter")   end
display(plot!(size=(1000,300),title="ω=$ω"
    ,xlabel = "position of sensors"
    ,ylabel= "measured field"))
savefig("square_multifrq$frq.png")
end


######## Average of curves
nb_sensors = length(Sensors_vline)
nb_config = 10;
nb_ω = 10;

M_resonators = zeros(nb_sensors,nb_ω,nb_config)
M_squares = zeros(nb_sensors,nb_ω,nb_config)

# resonators
for frq = 1:nb_ω;
    for config = 1:nb_config
        Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
        visibility(cloaking_resonators[frq,config],sensors_bottomleft,sensors_topright);
        M_resonators[:,frq,config] = field_vline[:,1];
    end
end

# squares
for config = 1:nb_config
    Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
    visibility(cloaking_squares[config],sensors_bottomleft,sensors_topright);
    for frq = 1:nb_ω
        M_squares[:,frq,config] = field_vline[:,frq];
    end
end

μ_M_resonators = mean(M_resonators,dims=3);
μ_M_squares = mean(M_squares,dims=3);

σ_M_resonators = std(M_resonators,dims=3);
σ_M_squares = std(M_squares,dims=3);

var_M_resonators = var(M_resonators,dims=3);
var_M_squares = var(M_squares,dims=3);


for frq = [4]
plot()
ω = round(list_ω[frq]; digits = 2)
plot(Sensors_vline,μ_M_squares[:,frq,1]
,grid=false,ribbon=σ_M_squares[:,frq,1],fillalpha=.5,label="",color=:red)
plot!(size=(1000,300),title="ω=$ω (resonant frequency ω₀)"
,xlabel = "position of sensors"
,ylabel= "averaged fields")
savefig("Average$frq.png")
end

for frq = [5]
plot()
ω = round(list_ω[frq]; digits = 2)
plot(Sensors_vline,μ_M_squares[:,frq,1]
,grid=false,ribbon=σ_M_squares[:,frq,1],fillalpha=.5,label="",color=:red)
plot!(size=(1000,300),title="ω=$ω"
,xlabel = "position of sensors"
,ylabel= "averaged fields")
savefig("Average$frq.png")
end


#######

# average and all curves together
iter = 0
for frq = [4];
  plot()
ω = round(list_ω[frq]; digits = 2)
  for config = 1:10
      Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
      visibility(cloaking_resonators[frq,config],sensors_bottomleft,sensors_topright);
      p1 = plot!(Sensors_vline,field_vline[:,1],ylim=(-1,1),label="",color=:black
      ,xlabel = ""
      ,ylabel= "measured field")
  end
p2 = plot(Sensors_vline,μ_M_resonators[:,frq,1]
    ,grid=false,ribbon=σ_M_resonators[:,frq,1]
    ,fillalpha=.5,label="",color=:blue
    ,xlabel = "position of sensors"
    ,ylabel= "Averaged fields")
display(plot(p1, p2,size=(1000,600),plot_title="ω=$ω (resonant frequency ω₀)",layout=(2,1)))
savefig("NewAverage$frq")
end

# average and all curves together
iter = 0
for frq = [5];
  plot()
ω = round(list_ω[frq]; digits = 2)
  for config = 1:10
      Sensors_mean,Sensors_hline,field_hline,Sensors_vline,field_vline,CX,CY=
      visibility(cloaking_resonators[frq,config],sensors_bottomleft,sensors_topright);
      p1 = plot!(Sensors_vline,field_vline[:,1],ylim=(-1,1),label="",color=:black
      ,xlabel = ""
      ,ylabel= "measured field")
  end
p2 = plot(Sensors_vline,μ_M_resonators[:,frq,1]
    ,grid=false,ribbon=σ_M_resonators[:,frq,1]
    ,fillalpha=.5,label="",color=:blue
    ,xlabel = "position of sensors"
    ,ylabel= "Averaged fields")
display(plot(p1, p2,size=(1000,600),plot_title="ω=$ω",layout=(2,1)))
savefig("NewAverage$frq")
end



#################################
# Plot fields
frq = 4
Ω = Particle(particle_medium_1, Circle([0.0,0.0], layer_radius));
big_sphere_scattering = Solve([list_ω[frq]],[Ω],40,40);
PlotMyWave(list_ω[frq],Ω,big_sphere_scattering)
savefig("uncloaked_scattering.png")


layer_particles = layer(1.0,2.0,0.5,
    t->layer_radius*cos(2π*t)
    ,t->layer_radius*sin(2π*t)
    ,t->-2π*layer_radius*sin(2π*t)
    ,t->2π*layer_radius*cos(2π*t));

#     # Resonator layer
res_layer_radius = Cockpit_radius*1.4
res_layer_particles = resonator_layer(0.0,0.0,3.0,
    t->res_layer_radius*cos(2π*t)
    ,t->res_layer_radius*sin(2π*t)
    ,t->-2π*res_layer_radius*sin(2π*t)
    ,t->2π*res_layer_radius*cos(2π*t)
    ,X);

Cockpit_centered = Particle(particle_medium_1, Circle([0.0,0.0], Cockpit_radius));

super_cloaked = [Cockpit_centered;res_layer_particles;layer_particles];
plot(super_cloaked)
cloaked_scattering = Solve([list_ω[frq]],super_cloaked,40,40);
PlotMyWave(list_ω[frq],super_cloaked,cloaked_scattering)
savefig("cloak_scattering.png")



for frq = 1:10
    ω = list_ω[frq]
    config = 2
    PlotMyWave(list_ω[frq],big_sphere,cloaking_resonators[frq,config])
    display(plot!(title="ω=$ω"))
end
