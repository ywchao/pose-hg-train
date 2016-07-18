
figure(1);

% hg-single-no-skip
log_file = './exp/mpii/hg-single-no-skip/valid.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'r'); hold on
subplot(1,2,2); plot(loss,'r'); hold on

% hg-single-no-skip clstm
log_file = './exp/mpii/hg-single-no-skip-clstm/valid.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'g');
subplot(1,2,2); plot(loss,'g');

% hg-single-no-skip res-clstm
log_file = './exp/mpii/hg-single-no-skip-res-clstm/valid.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'b');
subplot(1,2,2); plot(loss,'b');

% set legend
subplot(1,2,1);
legend('hg-single-no-skip', ...
    'hg-single-no-skip-clstm', ...
    'hg-single-no-skip-res-clstm', ...
    'Location', 'southeast');
subplot(1,2,2);
legend('hg-single-no-skip', ...
    'hg-single-no-skip-clstm', ...
    'hg-single-no-skip-res-clstm', ...
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
save_file = 'outputs/mean_pck_clstm.pdf';
if ~exist(save_file,'file')
    set(gcf,'PaperPosition',[0 0 8 3]);
    print(gcf,save_file,'-dpdf');
end

close;
