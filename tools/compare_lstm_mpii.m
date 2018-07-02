
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

% hg-single-no-skip lstm linear
log_file = './exp/mpii/hg-single-no-skip-lstm-ln/valid.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'g');
subplot(1,2,2); plot(loss,'g');

% hg-single-no-skip lstm linear dropout
log_file = './exp/mpii/hg-single-no-skip-lstm-ln-drop/valid.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'c');
subplot(1,2,2); plot(loss,'c');

% hg-single-no-skip lstm max
log_file = './exp/mpii/hg-single-no-skip-lstm-max/valid.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'m');
subplot(1,2,2); plot(loss,'m');

% hg-single-no-skip res-lstm max
log_file = './exp/mpii/hg-single-no-skip-res-lstm-max/valid.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'b');
subplot(1,2,2); plot(loss,'b');

% set legend
subplot(1,2,1);
h_leg = legend('hg-single-no-skip', ...
    'hg-single-no-skip lstm linear', ...
    'hg-single-no-skip lstm linear dropout', ...
    'hg-single-no-skip lstm max-pool', ...
    'hg-single-no-skip res-lstm max-pool', ...
    'Location', 'southeast');
set(h_leg,'FontSize',6);
subplot(1,2,2);
h_leg = legend('hg-single-no-skip', ...
    'hg-single-no-skip lstm linear', ...
    'hg-single-no-skip lstm linear dropout', ...
    'hg-single-no-skip lstm max-pool', ...
    'hg-single-no-skip res-lstm max-pool', ...
    'Location', 'northeast');
set(h_leg,'FontSize',6);

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
save_file = 'output/mean_pck_lstm.pdf';
if ~exist(save_file,'file')
    set(gcf,'PaperPosition',[0 0 8 3]);
    print(gcf,save_file,'-dpdf');
end

close;
