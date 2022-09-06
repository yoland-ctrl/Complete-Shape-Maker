clc; clear; close all;
%% Shape Maker Program %%
shapeName = input('Enter shape type: ','s');
%Square
if shapeName == 'Square'
    square_shape(); 
end
%Circle
if shapeName == 'Circle'
    circle_shape();
end
%% 
function fileID = square_shape()
printType = input('Raster or Spiral? ','s');
length = input('Enter shape side length (um): ','s');
dsp = input('Enter drop spacing (um): ','s');
length = str2num(length);
dsp = str2num(dsp);
maxDrops = round(length/dsp);
maxDrops2 = round(length/dsp);
x1 = zeros(maxDrops, 1);
for i=1:maxDrops
    x1(i) = dsp;
    x_drop = x1;
end
x_zeroes = zeros(maxDrops, 1);
A = [x_zeroes, x_drop];
B = [x_drop, x_zeroes];
mmSize = length/1000; 
s = strcat(printType,'_', num2str(mmSize),'mm_', num2str(dsp),'dsp.txt');
fileID = fopen(s,'w');
fprintf(fileID,'%5d,%5d \n', 0,0);
if printType == 'Spiral'
    for i=1:maxDrops
        fprintf(fileID,'%5d,', A(i, 1));
        fprintf(fileID,'%5d \n', A(i, 2));
    end
    for i=1:maxDrops
        fprintf(fileID,'%5d,', B(i, 1));
        fprintf(fileID,'%5d \n', B(i, 2));
    end
    for i=1:maxDrops
        fprintf(fileID,'%5d,', A(i, 1));
        fprintf(fileID,'%5d \n', -A(i, 2));
    end
    for i=1:maxDrops-1
        fprintf(fileID,'%5d,', -B(i, 1));
        fprintf(fileID,'%5d \n', B(i, 2));
    end
    maxDrops = maxDrops-1;
 while maxDrops > 0
    for i=1:maxDrops
        fprintf(fileID,'%5d,', A(i, 1));
        fprintf(fileID,'%5d \n', A(i, 2));
    end
    for i=1:maxDrops-1
        fprintf(fileID,'%5d,', B(i, 1));
        fprintf(fileID,'%5d \n', B(i, 2));
    end
    for i=1:maxDrops-1
        fprintf(fileID,'%5d,', A(i, 1));
        fprintf(fileID,'%5d \n', -A(i, 2));
    end
    for i=1:maxDrops-2
        fprintf(fileID,'%5d,', -B(i, 1));
        fprintf(fileID,'%5d \n', B(i, 2));
    end
    maxDrops = maxDrops-2;
 end
end
if printType == 'Raster'
    while maxDrops2 > 0
    for i=1:maxDrops
        fprintf(fileID,'%5d,', A(i, 1));
        fprintf(fileID,'%5d \n', A(i, 2));
    end
    fprintf(fileID,'%5d,%5d \n', B(1, :));
    for i=1:maxDrops
        fprintf(fileID,'%5d,', A(i, 1));
        fprintf(fileID,'%5d \n', -A(i, 2));
    end
    fprintf(fileID,'%5d,%5d \n', B(1, :));
    maxDrops2 = maxDrops2-2;
    end
    for i=1:maxDrops
        fprintf(fileID,'%5d,', A(i, 1));
        fprintf(fileID,'%5d \n', A(i, 2));
    end
end
end
%%
function fileID = circle_shape()
    diameter = input('Enter diameter (um): ','s');
    dsp = input('Enter drop spacing (um): ','s');
    diameter = str2num(diameter);
    dsp = str2num(dsp);
    radius = diameter/2;
    mmSize = diameter/1000;
    s = strcat('Circle_', num2str(mmSize),'mm_', num2str(dsp),'dsp.txt');
    fileID = fopen(s,'w');
    % Array with Circle Coordinates 
    A=[];
    while radius > 0
        c=double(2*pi*radius);
        n=double(int8(c/dsp)); %number of drops in circle
        %c=double(n*dsp); 
        radius=c/(2*pi);
        a=(2*pi)/n;
        for  th = 0:a:(2*(pi))
            xunit = (radius * cos(th));
            yunit = (radius * sin(th));
            B=[xunit,yunit];
            A=[A;B];
            figure(1)
            hold on
            plot(xunit, yunit, 'o');
        end
        radius = (radius-dsp);
    end
    % Make printable file
    Circle = [];
    for i=1:(length(A)-1)
       A1=[A(i+1, :)-A(i, :)];
       Circle=[Circle;A1];
    end
    % Save data in file
    fileID = fopen(s,'w');
    fprintf(fileID,'%5d,%5d \n', 0,0);
        for i=1:length(Circle)
            fprintf(fileID,'%5d, ', Circle(i, 1));
            fprintf(fileID,'%5d \n', Circle(i, 2));
        end
end