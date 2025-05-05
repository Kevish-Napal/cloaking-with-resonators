# Parameters on one resonator
cavity_radius = 1.0;
cavity_length = 2.5;
mouth_radius = 0.3;
mouth_length = 0.5;

# Expected Resonance: ω0 = sqrt(S/(VL)) (didn't work)
S = pi * mouth_radius^2;
L = mouth_length;
V = pi * cavity_radius^2 * cavity_length;

# The resonator is made of small sound hard particles
radius = .1;# radius of obstacles
dimension = 2;
host_medium = Acoustic(dimension; ρ=1.0, c=1.0);
particle_medium =  Acoustic(dimension; ρ = 0., c = 0.);

# Define one resonator as collection of particles
d_particle = 2.001*radius; # distance between centers

# define Cavity
cavity_up = [[x,cavity_radius+radius] for x=radius:d_particle:cavity_length];
cavity_down = [[x,-cavity_radius-radius] for x=radius:d_particle:cavity_length]
cavity_right = [[cavity_length+.05*radius,y] for y=(-cavity_radius-radius):d_particle:(cavity_radius+2*radius)]

# define mouth
mouth_connect_down = [[radius-d_particle,y] for y=(-cavity_radius-radius):d_particle:(-mouth_radius)]
mouth_connect_up = [[radius-d_particle,y] for y=(mouth_radius+radius):d_particle:(cavity_radius+2*radius)]
mouth_up = [[x,mouth_radius+radius] for x = radius-2*d_particle:-d_particle:-mouth_length-radius]
mouth_down = [[x,-mouth_radius-radius] for x = radius-2*d_particle:-d_particle:-mouth_length-radius]


X = [cavity_up;cavity_down;cavity_right;mouth_connect_down;mouth_connect_up;mouth_up;mouth_down];
X = [x - [cavity_length/2,cavity_radius/2-0.5] for x in X];
Resonator = [Particle(particle_medium, Circle(x, radius)) for x in X];

# resonant frequencies found
ω0 = 1.990189942693913;
ω2 = 3.990;


# Check overlapping pairs
overlapping_pairs(Resonator)



### We also define a close square here
# Define one resonator
d_particle = 2.001*radius; # distance between centers
cavity_left = [[radius-d_particle,y] for y=(-cavity_radius-radius):d_particle:(cavity_radius+2*radius)]
XS = [cavity_up;cavity_down;cavity_right;cavity_left];
XS = [x - [cavity_length/2,cavity_radius/2-0.5] for x in XS];
Square = [Particle(particle_medium, Circle(x, radius)) for x in XS];
