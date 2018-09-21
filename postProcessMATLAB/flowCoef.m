function mu = flowCoef(u, G, h, f_valve, p_inlet)

%% Initialising arrays
p_delta = zeros(length(h), 1);
G_teor = zeros(length(h), 1);
mu = zeros(length(h), 1);

%% Calculating flow coefficient for a version of geometry

for i = 1:length(h)
    p_delta(i) = p_inlet.data(i,2) + power(u, 2)/2; % m^2/s^2 
    G_teor(i) = f_valve(i)*sqrt(2*p_delta(i));
	
    mu(i) = G / G_teor(i);
    
end

end

