clear all
load b

symbols = textread('C:\momentum\data\symbols\successfullyReformattedSymbols.txt', '%s');
fid = fopen('C:\momentum\data\weka\train.csv','w');
fprintf(fid,'p01day(i), p02day(i), b(i), symbol, l1, dailyReturn1, tradingDayReturn1, label, percentGood\n');

p01Day=zeros(size(symbols,1),1);
p02Day=zeros(size(symbols,1),1);

for i=1:size(symbols,1)
    symbol=symbols{i};
    fprintf('Processing symbol %s\n', symbol);
    filename = strcat('C:\momentum\data\train\', symbol, '.csv');
    stock=load(filename);
    
    % withhold a testing set
    stock = stock(1:floor(size(stock,1)/2),:);
    
    openPrice=stock(:,2);
    highPrice=stock(:,3);
    lowPrice=stock(:,4);
    closePrice=stock(:,5);

    for time=1:size(openPrice,1)
        a=(highPrice(time)-openPrice(time))/openPrice(time);
        if(a>0.02)
            p02Day(i)=p02Day(i)+1;
        else
           
        end
        if(a>0.01)
            p01Day(i)=p01Day(i)+1;
        else
            
        end
    end
    p01Day(i)=p01Day(i)/size(openPrice,1);
    p02Day(i)=p02Day(i)/size(openPrice,1);

    % main loop to build examples
    window=20;
    for time=window+1:size(openPrice,1)

        % percentGood
        percentGood=0.0;
        for t=time-window:time
            if(highPrice(t)>openPrice(t)*1.02)
                percentGood=percentGood+1;
            end
        end
        percentGood=percentGood/window;
        
        % l1
        l1=(highPrice(time-1)-openPrice(time-1))/openPrice(time-1);
        
        %dailyReturn1
        dailyReturn1=(closePrice(time-2)-closePrice(time-1))/closePrice(time-1);
        
        %tradingDayReturn1
        tradingDayReturn1=(closePrice(time-1)-openPrice(time-1))/openPrice(time-1);
        
        % compute label
        if(highPrice(time)>openPrice(time)*1.02)
            label='Good';
        elseif(closePrice(time)>openPrice(time))
            label='OK';
        elseif(closePrice(time)>openPrice(time)*0.98)
            label='Bad';
        else
            label='Very Bad';
        end

        %if(l1>0.08 || dailyReturn1<-0.06 || tradingDayReturn1>0.08)
        %if(l1>0.1 || dailyReturn1<-0.1 || tradingDayReturn1>0.1)
         %   fprintf(fid,'%f,%f,%s,%f,%f,%f,%s, %f\n', p01Day, p02Day, b(i), symbol, l1, dailyReturn1, tradingDayReturn1, label, percentGood);
            %end
            %end
    end
end
fclose(fid)