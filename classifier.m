
function Class = classifier(path_training_file,path_test_file,output_edited_test,output_edited_training) %output_edited_training
A = importdata(path_training_file);
Z=zeros(1,230)
W=zeros(1,46);
X=zeros(1,23);
Y=zeros(1,23);
F=zeros(1,21);
Dist=zeros(1,20);
Dist2=zeros(1,20);
%Class=zeros(100,1);
Fmatrix= zeros(100,21);
FTmatrix= zeros(100,21);
Results= zeros(100,21);
Avgmatrix = zeros(20,21);
avgx = zeros(1,23);
avgy = zeros(1,23);

n=1;
m=1;
animal=1;

%View column 1
for k = 1 %lines
  % disp(A.rowheaders{k, 1}) ;
  % disp(A.data(k,:));
  % disp(' ');
   
   %disp(A.rowheaders{k, 1})
  % disp(A.data(k,:))
end

%sqrt((ax-bx)^2+(ay-by)^2);
%copying column to vector in workspace
for i=[1:46] 
    W(i)=A.data(animal,i);
    %Split into X and Y coordinate vectors
    %test if number is odd or even (odd numbers will be X coordinates and even Y coordinates)
    if mod(i,2)==1
        X(n)=A.data(animal,i);
        n=n+1;
    else
        Y(m)=A.data(animal,i);
        m=m+1;
    end       
end

%perform plot
%plot(X,Y)

% % %Start trainning
% %First step, get the average of each animal
%Algorithm for computing the vector of average features of each animal
for animal=[1:100]
 for i=[1:46] 
    W(i)=A.data(animal,i);
    %Split into X and Y coordinate vectors
    %test if number is odd or even (odd numbers will be X coordinates and even Y coordinates)
    if mod(i,2)==1
        X(n)=A.data(animal,i);
        n=n+1;
    else
        Y(m)=A.data(animal,i);
        m=m+1;
    end       
 end
 %Extract features
 F=featuresExt(X,Y);
 %build Feature matrix
 Fmatrix(animal,:) = F;
 %reset m and n 
 m=1;
 n=1;
end

%Create Average feature matrix
line=1;
count=1;
for species=[0:5:95] %20 species of animals, each animal has 5 training set of points, in total there are 100 animals on training file
    for i=[1:5]
        for j = [1:21]
         Avgmatrix(line,j)= Avgmatrix(line,j)+ Fmatrix(i+species,j);
        end
    end
    line=line+1;
end
Avgmatrix= Avgmatrix/5;

%create classifier based on Euclidian distance
%need to get distance between each feature from the average with each
%feature from the animal in the test file
%Need to extract features for each animal on the test file -> create a
%matrix

%Extract features for each animal on the test file
%could implement first a counter to see how many animals are in the text
%file
T = importdata(path_test_file);
for animal=[1:100]
 for i=[1:46] 
    M(i)=T.data(animal,i);
    %Split into X and Y coordinate vectors
    %test if number is odd or even (odd numbers will be X coordinates and even Y coordinates)
    if mod(i,2)==1
        Xm(n)=T.data(animal,i);
        n=n+1;
    else
        Ym(m)=T.data(animal,i);
        m=m+1;
    end       
 end
 %Extract features
 F=featuresExt(Xm,Ym);
 %build Feature matrix
 FTmatrix(animal,:) = F;
 %reset m and n 
 m=1;
 n=1;
end

%need to get distance between each feature from the average with each
%feature from the animal in the test file
%Euclidian distance
%d = sqrt((x1-t1)^2 + (x2-t2)^2 +.....+(xn-tn)^2) X= input vector, T= template
%vector
sum=0;
% weight= zeros(1,21);
 weight(1)=1;
 weight(2)=3;
 weight(3)=0.7; 
 weight(4)=4; 
 weight(5)=2.5; 
 weight(6)=1;
 weight(7)=6;
 weight(8)=5; 
 weight(9)=1; 
 weight(10)=4;
 weight(11)=3;
 weight(12)=0.3;
 weight(13)=0.5;
 weight(14)=1;
 weight(15)=3;
 weight(16)=7;
 weight(17)=3.5; 
 weight(18)=5;
 weight(19)=0.7;
 weight(20)=0.3;
 weight(21)=0.9;
Distmatrix =zeros(100,21);
input=0;
for i =[1:100] %input
    for j=[1:20] %template
        for k=[1:21] %feature
%             if (k==2|k==3|k== 11| k== 15|k== 16|k== 17 |k== 18) %if (k == 2| k== 4 | k== 13| k== 14| k== 15)
%             sum = sum + 3*((FTmatrix(i,k)- Avgmatrix(j,k))^2); %using weights so that if they differ in this aspects their diference will be bigger
%             elseif ( k== 21| k==20|k==9)
%             sum = sum + 0.8*((FTmatrix(i,k)- Avgmatrix(j,k))^2);
%             else
%             sum = sum + 0.8*((FTmatrix(i,k)- Avgmatrix(j,k))^2);
%             end 
            sum = sum + weight(k)*((FTmatrix(i,k)- Avgmatrix(j,k))^2); %using weights so that if they differ in this aspects their diference will be bigger
            Dist2(k)=(FTmatrix(77,k)- Avgmatrix(1,k))^2;
        end
        Dist(j)=sqrt(sum); %Euclidian distance     
        if(i==2)
        z=2;
        %Dist2(j)=sum; %Euclidian distance
        end
        sum=0;
    end
    %check the shortest distance
    [M,I] = min(Dist(:));
    %vector with the minimun indicies -> hand classification
    %Class(i)=I;
    %%%Getting animal name
    Class(i,1)= A.rowheaders(I*5);
end 
%%Filling rest of file

for i =[1:100] %input
    for j=[2:47]
    Class{i,j}= T.data(i,j-1);
    end    
end

%%Save test result to file
% fileID = fopen(output_edited_test,'w');
% [nrows,ncols] = size(Class);
% for row = 1:nrows
%     fprintf(fileID,'%s \n',Class{row,:});
% end
% fclose(fileID);

%%Save test result to file
%file
cd= fullfile(output_edited_training,'testfile_output.txt');
fileID = fopen(cd,'w');
for i =[1:100] %input
    for j=[1:47]
      if j==1
        fprintf(fileID,'%s ', Class{i,1}); 
      elseif j ==47
          fprintf(fileID,'%d\n', Class{i,j});
      else    
        fprintf(fileID,'%d ', Class{i,j});
      end
    end
end
fclose(fileID);

%%%%%%%%%%%%%%Training file
%Extract features for each animal on the test file
%could implement first a counter to see how many animals are in the text
T = importdata(path_training_file);
for animal=[1:100]
 for i=[1:46] 
    M(i)=T.data(animal,i);
    %Split into X and Y coordinate vectors
    %test if number is odd or even (odd numbers will be X coordinates and even Y coordinates)
    if mod(i,2)==1
        Xm(n)=T.data(animal,i);
        n=n+1;
    else
        Ym(m)=T.data(animal,i);
        m=m+1;
    end       
 end
 %Extract features
 F=featuresExt(Xm,Ym);
 %build Feature matrix
 FTmatrix(animal,:) = F;
 %reset m and n 
 m=1;
 n=1;
end

%need to get distance between each feature from the average with each
%feature from the animal in the test file
%Euclidian distance
%d = sqrt((x1-t1)^2 + (x2-t2)^2 +.....+(xn-tn)^2) X= input vector, T= template
%vector
sum=0;
% weight= zeros(1,21);
 weight(1)=1;
 weight(2)=3;
 weight(3)=0.7; 
 weight(4)=4; 
 weight(5)=2.5; 
 weight(6)=1;
 weight(7)=6;
 weight(8)=5; 
 weight(9)=1; 
 weight(10)=4;
 weight(11)=3;
 weight(12)=0.3;
 weight(13)=0.5;
 weight(14)=1;
 weight(15)=3;
 weight(16)=7;
 weight(17)=3.5; 
 weight(18)=5;
 weight(19)=0.7;
 weight(20)=0.3;
 weight(21)=0.9;
Distmatrix =zeros(100,21);
input=0;
for i =[1:100] %input
    for j=[1:20] %template
        for k=[1:21] %feature
%             if (k==2|k==3|k== 11| k== 15|k== 16|k== 17 |k== 18) %if (k == 2| k== 4 | k== 13| k== 14| k== 15)
%             sum = sum + 3*((FTmatrix(i,k)- Avgmatrix(j,k))^2); %using weights so that if they differ in this aspects their diference will be bigger
%             elseif ( k== 21| k==20|k==9)
%             sum = sum + 0.8*((FTmatrix(i,k)- Avgmatrix(j,k))^2);
%             else
%             sum = sum + 0.8*((FTmatrix(i,k)- Avgmatrix(j,k))^2);
%             end 
            sum = sum + weight(k)*((FTmatrix(i,k)- Avgmatrix(j,k))^2); %using weights so that if they differ in this aspects their diference will be bigger
            Dist2(k)=(FTmatrix(77,k)- Avgmatrix(1,k))^2;
        end
        Dist(j)=sqrt(sum); %Euclidian distance     
        if(i==2)
        z=2;
        %Dist2(j)=sum; %Euclidian distance
        end
        sum=0;
    end
    %check the shortest distance
    [M,I] = min(Dist(:));
    %vector with the minimun indicies -> hand classification
    %Class(i)=I;
    %%%Getting animal name
    Class(i,1)= A.rowheaders(I*5);
end 
%%Filling rest of file

for i =[1:100] %input
    for j=[2:47]
    Class{i,j}= T.data(i,j-1);
    end    
end

%%Save test result to file
% fileID = fopen(output_edited_test,'w');
% [nrows,ncols] = size(Class);
% for row = 1:nrows
%     fprintf(fileID,'%s \n',Class{row,:});
% end
% fclose(fileID);

%%Save test result to file
cd= fullfile(output_edited_training,'trainfile_output.txt');
fileID = fopen(cd,'w');
for i =[1:100] %input
    for j=[1:47]
      if j==1
        fprintf(fileID,'%s ', Class{i,1}); 
      elseif j ==47
          fprintf(fileID,'%d\n', Class{i,j});
      else    
        fprintf(fileID,'%d ', Class{i,j});
      end
    end
end
fclose(fileID);




end


%Algorithm for extracting features,
%Widths using euclidian distance
%fingers width
%angles
function [f]= featuresExt(X,Y)
%pa- pb = sqrt((ax-bx)^2+(ay-by)^2);
%w1= p2-p6
ax= X(2);
ay=Y(2);
bx=X(6);
by=Y(6);
w1=sqrt((ax-bx)^2+(ay-by)^2);
%w2= p3-p5
ax= X(3);
ay=Y(3);
bx=X(5);
by=Y(5);
w2=sqrt((ax-bx)^2+(ay-by)^2);
%w3=p6-p10
ax= X(6);
ay=Y(6);
bx=X(10);
by=Y(10);
w3=sqrt((ax-bx)^2+(ay-by)^2);
%w4=p7-p9
ax= X(7);
ay=Y(7);
bx=X(9);
by=Y(9);
w4=sqrt((ax-bx)^2+(ay-by)^2);
%w5=p10-p14
ax= X(10);
ay=Y(10);
bx=X(14);
by=Y(14);
w5=sqrt((ax-bx)^2+(ay-by)^2);
%w6=p11-p13
ax= X(11);
ay=Y(11);
bx=X(13);
by=Y(13);
w6=sqrt((ax-bx)^2+(ay-by)^2);
%w7=p14-p18
ax= X(14);
ay=Y(14);
bx=X(18);
by=Y(18);
w7=sqrt((ax-bx)^2+(ay-by)^2);
%w8=p15-p17
ax= X(15);
ay=Y(15);
bx=X(17);
by=Y(17);
w8=sqrt((ax-bx)^2+(ay-by)^2);
%w9=p19-p23
ax= X(19);
ay=Y(19);
bx=X(23);
by=Y(23);
w9=sqrt((ax-bx)^2+(ay-by)^2);
%w10=p20-p22
ax= X(20);
ay=Y(20);
bx=X(22);
by=Y(22);
w10=sqrt((ax-bx)^2+(ay-by)^2);
%palm width
%w11=p2-p14
ax= X(2);
ay=Y(2);
bx=X(14);
by=Y(14);
w11=sqrt((ax-bx)^2+(ay-by)^2);
%w12=p1-p18
ax= X(1);
ay=Y(1);
bx=X(18);
by=Y(18);
w12=sqrt((ax-bx)^2+(ay-by)^2);
%w13 = p1-p19
ax= X(1);
ay=Y(1);
bx=X(19);
by=Y(19);
w13=sqrt((ax-bx)^2+(ay-by)^2);
%w14=p6-p14
ax= X(6);
ay=Y(6);
bx=X(14);
by=Y(14);
w14=sqrt((ax-bx)^2+(ay-by)^2);
%w15=p18-p19
ax= X(18);
ay=Y(18);
bx=X(19);
by=Y(19);
w15=sqrt((ax-bx)^2+(ay-by)^2);

%Fingers lenght
%l1= d of p4 and ((p2+p6)/2)
pmx= (X(2)+X(6))/2;
pmy= (Y(2)+Y(6))/2;
bx=X(4);
by=Y(4);
l1=sqrt((pmx-bx)^2+(pmy-by)^2);
%l2=p8 (p6 p10)
pmx= (X(6)+X(10))/2;
pmy= (Y(6)+Y(10))/2;
bx=X(8);
by=Y(8);
l2=sqrt((pmx-bx)^2+(pmy-by)^2);
%l3=p12 (p10 p14)
pmx= (X(2)+X(6))/2;
pmy= (Y(2)+Y(6))/2;
bx=X(4);
by=Y(4);
l3=sqrt((pmx-bx)^2+(pmy-by)^2);
%l4=p16 (P14 P18)
pmx= (X(14)+X(18))/2;
pmy= (Y(14)+Y(18))/2;
bx=X(16);
by=Y(16);
l4=sqrt((pmx-bx)^2+(pmy-by)^2);
%l5=P21 (P19 P23)
pmx= (X(19)+X(23))/2;
pmy= (Y(19)+Y(23))/2;
bx=X(21);
by=Y(21);
l5=sqrt((pmx-bx)^2+(pmy-by)^2);

%Angles
%cos C = (a^2+b^2-c^2)/2ab
%angle1
%a= p6-p10 = w3
%b=p16-p14 =w5
%c=p10-p4=w14
a=w3;
b=w14;
c=w5;
cosC=(a^2+b^2-c^2)/(2*a*b);
a1= acos(cosC)*1000

%angle1
%a= p6-p10 = w3
%b=p16-p14 =w5
%c=p10-p4=w14
a=w12;
b=w13;
c=w15;
cosC=(a^2+b^2-c^2)/(2*a*b);
a2= acos(cosC)*1000

  f =[w1, w2, w3, w4, w5, w6,w7,w8,w9,w10,w11, w12,w13,w14,l1,l2,l3,l4,l5,a1,a2]; %21 features
%
end