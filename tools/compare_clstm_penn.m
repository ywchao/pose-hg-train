
figure(1);

% hg-single-no-skip-ft train
log_file = './exp/penn_action_cropped/hg-single-no-skip-ft/train.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'--r'); hold on;
subplot(1,2,2); plot(loss,'--r'); hold on;

% hg-single-no-skip-ft val
log_file = './exp/penn_action_cropped/hg-single-no-skip-ft/valid.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'r');
subplot(1,2,2); plot(loss,'r');

% hg-single-no-skip-ft test
log_file = './exp/penn_action_cropped/hg-single-no-skip-ft-final-preds/test.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot([1,100],[acc,acc],'r:');
subplot(1,2,2); plot([1,100],[loss,loss],'r:');

% hg-single-no-skip-clstm-ft train
log_file = './exp/penn_action_cropped/hg-single-no-skip-clstm-ft/train.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'--g');
subplot(1,2,2); plot(loss,'--g');

% hg-single-no-skip-clstm-ft valid
log_file = './exp/penn_action_cropped/hg-single-no-skip-clstm-ft/valid.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'g');
subplot(1,2,2); plot(loss,'g');

% hg-single-no-skip-clstm-ft test
log_file = './exp/penn_action_cropped/hg-single-no-skip-clstm-ft-final-preds/test.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot([1,100],[acc,acc],'g:');
subplot(1,2,2); plot([1,100],[loss,loss],'g:');

% hg-single-no-skip-res-clstm-ft train
log_file = './exp/penn_action_cropped/hg-single-no-skip-res-clstm-ft/train.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'--b');
subplot(1,2,2); plot(loss,'--b');

% hg-single-no-skip-res-clstm-ft valid
log_file = './exp/penn_action_cropped/hg-single-no-skip-res-clstm-ft/valid.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'b');
subplot(1,2,2); plot(loss,'b');

% hg-single-no-skip-res-clstm-ft test
log_file = './exp/penn_action_cropped/hg-single-no-skip-res-clstm-ft-final-preds/test.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot([1,100],[acc,acc],'b:');
subplot(1,2,2); plot([1,100],[loss,loss],'b:');

% set legend
subplot(1,2,1);
h_leg = legend('hg-single-no-skip fine-tune (train)', ...
    'hg-single-no-skip fine-tune (valid)', ...
    'hg-single-no-skip fine-tune (test)', ...
    'hg-single-no-skip-clstm fine-tune (train)', ...
    'hg-single-no-skip-clstm fine-tune (valid)', ...
    'hg-single-no-skip-clstm fine-tune (test)', ...
    'hg-single-no-skip-res-clstm fine-tune (train)', ...
    'hg-single-no-skip-res-clstm fine-tune (valid)', ...
    'hg-single-no-skip-res-clstm fine-tune (test)', ...
    'Location', 'southeast');
set(h_leg,'FontSize',4);
subplot(1,2,2);
h_leg = legend('hg-single-no-skip fine-tune (train)', ...
    'hg-single-no-skip fine-tune (valid)', ...
    'hg-single-no-skip fine-tune (test)', ...
    'hg-single-no-skip-clstm fine-tune (train)', ...
    'hg-single-no-skip-clstm fine-tune (valid)', ...
    'hg-single-no-skip-clstm fine-tune (test)', ...
    'hg-single-no-skip-res-clstm fine-tune (train)', ...
    'hg-single-no-skip-res-clstm fine-tune (valid)', ...
    'hg-single-no-skip-res-clstm fine-tune (test)', ...
    'Location', 'northeast');
set(h_leg,'FontSize',4);

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
save_file = 'outputs/mean_pck_clstm_penn.pdf';
if ~exist(save_file,'file')
    set(gcf,'PaperPosition',[0 0 8 3]);
    print(gcf,save_file,'-dpdf');
end

close;
