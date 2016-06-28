
figure(1);

% pr-etrained
log_file = './exp/mpii/umich-stacked-hourglass/valid.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot([1,100],[acc,acc],'r--'); hold on;
subplot(1,2,2); plot([1,100],[loss,loss],'r--'); hold on;

% default
log_file = './exp/mpii/default/valid.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'r');
subplot(1,2,2); plot(loss,'r');

% hg-single
log_file = './exp/mpii/hg-single/valid.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'g');
subplot(1,2,2); plot(loss,'g');

% hg-single-no-skip
log_file = './exp/mpii/hg-single-no-skip/valid.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'b');
subplot(1,2,2); plot(loss,'b');

% set legend
subplot(1,2,1);
legend('hg-stacked pre-trained', ...
    'hg-stacked re-trained', ...
    'hg-single', ...
    'hg-single-no-skip', ...
    'Location', 'southeast');
subplot(1,2,2);
legend('hg-stacked pre-trained', ...
    'hg-stacked re-trained', ...
    'hg-single', ...
    'hg-single-no-skip', ...
    'Location', 'northeast');

% set other properties
subplot(1,2,1);
grid on;
set(gca,'fontsize',8);
xlabel('epoch');
ylabel('mean PCK');
subplot(1,2,2);
grid on;
set(gca,'fontsize',8);
xlabel('epoch');
ylabel('loss');

% save to file
save_file = 'outputs/mean_pck.pdf';
if ~exist(save_file,'file')
    set(gcf,'PaperPosition',[0 0 8 3]);
    print(gcf,save_file,'-dpdf');
end

close;
