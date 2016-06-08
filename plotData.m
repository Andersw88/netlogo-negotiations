clear all

m = csvread('data.csv');
x = m(:,2);
y3 = m(:,3); %Negotiation time
y2 = m(:,4); %Scan time
y = y3 + y2; %Total time

x_u = unique(x)';
means = zeros(size(x_u));
stds = zeros(size(x_u));
for i = 1:length(x_u)
    means(i) = mean(m(m(:,2) == x_u(i),4));
    stds(i) = std(m(m(:,2) == x_u(i),4));
end

[means',stds']

errorbar(x_u, means, stds, 'b-'); hold on;
plot(x_u, means, 'bx');
xlabel('No of agents');
ylabel('Ticks taken to complete');	