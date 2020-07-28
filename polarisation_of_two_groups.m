% Assignment Part 4

%Schelling-style model
clear all

%first we set up a world with randomly scattered economists and
%psychologists

nside=50; %the number of agents on each side of the matrix
randworld=rand(nside,nside); %Or could use round(rand(nside,nside))
world=randworld>.5; %say psychologist=0; economist=1;

colormap([0 1 0; 1 0 0]);% sets psychs as green , econs as red

numsadecons=100; numsadpsychs=100; %give these temp high values just to satisfy the while condition

while (numsadecons>50) && (numsadpsychs>50)
    
    %first calcuate number of econs surrounding each agent
    A=circshift(world,1); B=circshift(world,-1);
    C=circshift(world',1)'; D=circshift(world',-1)';
    topleft=circshift(A',1)'; topright=circshift(A',-1)';
    bottomleft=circshift(B',1)'; bottomright=circshift(B',-1)'; %agents now considers whole neighbourhood around them
    necon=A+B+C+D+topleft+topright+bottomleft+bottomright; %now necon has numbers of econ neighbours for each person in world
    
    %Now determine the unhappy econs
    sadecons=world.*((world.*necon)<6); %an econ wants to be around at least 3 econs
    
    %Now determine the unhappy psychs
    sadpsychs=abs(world-1).*((abs(world-1).*necon)>2); %a psych is unhappy around > 1 econ
    
    numsadecons=sum(sum(sadecons)); numsadpsychs=sum(sum(sadpsychs));
    
    %now choose a random sad econ and change to be a psych:
    [r,c]=find(sadecons); %get the row and col indices of all sad econs
    index=ceil(rand*numsadecons); %choose a random sad econ
    
    spA=circshift(sadpsychs,1); spB=circshift(sadpsychs,-1);
    spC=circshift(sadpsychs',1)'; spD=circshift(sadpsychs',-1)';
    
    %change the econ to a psych (adjacent)
    if spB(r(index),c(index))==1; % if below is sad psych, switch
        wb=circshift(world,-1);
        wb(r(index),c(index))=1;
        world=circshift(wb,1);
        world(r(index),c(index))=0;
    elseif spA(r(index),c(index))==1; % if above is sad psych, switch
        wa=circshift(world,1);
        wa(r(index),c(index))=1;
        world=circshift(wa,-1);
        world(r(index),c(index))=0;
    elseif spD(r(index),c(index))==1; % if right is sad psych, switch
        wd=circshift(world',-1)';
        wd(r(index),c(index))=1;
        world=circshift(wd',1)';
        world(r(index),c(index))=0;
    else spC(r(index),c(index))==1; % if left is sad psych, switch
        wc=circshift(world',1)';
        wc(r(index),c(index))=1;
        world=circshift(wc',-1)';
        world(r(index),c(index))=0;
    end
    
    %now choose a random sad psych and change to be an econ:
    [r,c]=find(sadpsychs); %get the row and col indices of all sad psychs
    index=ceil(rand*numsadpsychs); %choose a random sad psych
    
    seA=circshift(sadecons,1); seB=circshift(sadecons,-1);
    seC=circshift(sadecons',1)'; seD=circshift(sadecons',-1)';
    
    %change the psych to a econ (adjacent)
    if seB(r(index),c(index))==1; % if below is sad econ, switch
        wb=circshift(world,-1);
        wb(r(index),c(index))=0;
        world=circshift(wb,1);
        world(r(index),c(index))=1;
    elseif seA(r(index),c(index))==1; % if above is sad econ, switch
        wa=circshift(world,1);
        wa(r(index),c(index))=0;
        world=circshift(wa,-1);
        world(r(index),c(index))=1;
    elseif seD(r(index),c(index))==1; % if right is sad econ, switch
        wd=circshift(world',-1)';
        wd(r(index),c(index))=0;
        world=circshift(wd',1)';
        world(r(index),c(index))=1;
    else seC(r(index),c(index))==1; % if left is sad econ, switch
        wc=circshift(world',1)';
        wc(r(index),c(index))=0;
        world=circshift(wc',-1)';
        world(r(index),c(index))=1;
    end
    imagesc(world) %draw a colourmap
    pause(0.01) %pause for 0.01 second
    
end
% if one of either or both can tolerate two different neighbours, 
%segregation happens to a lesser degree
% if can only switch with adjacent neighbours, segregation takes much
% longer, some econs/psychs manage to end up trapped
