
x = 2:14;
y = [3947, 3415, 3456, 2280, 2191, 2714, 2317, 1955, 2260, 2826, 1712, 1508, 1752];
y2 = [1,15, 45, 49, 77, 125, 231, 213, 397,309,377,447,545];

y3 = y-y2;





c1 = polyfit(x, y, 1);
c2 = polyfit(x, y2, 1);
c3 = polyfit(x, y3, 1);
fx = linspace(min(x), max(x), 200);
fy = polyval(c1, fx);
fy2 = polyval(c2, fx);
fy3 = polyval(c3, fx);
plot(x,y,'x','Color','r'); hold on;

plot(x,y3,'x','Color','green'); hold on;
plot(x,y2,'x','Color','blue'); hold on;
plot(fx, fy,'Color','red');
plot(fx, fy2,'Color','blue');
plot(fx, fy3,'Color','green');
legend('Total time','Scan time','Negotiation time');